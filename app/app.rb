require 'sinatra'
require 'json'
require 'openssl'
require 'jwt'
require 'octokit'
require 'dotenv/load'
require 'pry'

require_relative 'decorators/event'

set :port, 3000

post '/' do
  request.body.rewind
  payload_body = request.body.read

  verify_signature(payload_body, request.env['HTTP_X_HUB_SIGNATURE'])

  event_data = JSON.parse(payload_body)
  event = Decorators::Event.new(event_data)

  if request.env['HTTP_X_GITHUB_EVENT'] == 'issues' && event.issue_opened?
    handle_issue_opened(event)
  end

  status 200
end

helpers do
  def verify_signature(payload_body, signature)
    secret = ENV['WEBHOOK_SECRET']
    sha1 = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload_body)
    halt 401, "Signatures didn't match!" unless Rack::Utils.secure_compare(sha1, signature)
  end

  def handle_issue_opened(event)
    unless event.estimate_present?
      post_comment(event.repo_full_name, event.issue_number)
    end
  end

  def post_comment(repo_full_name, issue_number)
    client = github_client(repo_full_name)
    comment_body = "Please add an estimate to this issue in the format 'Estimate: X days'."
    client.add_comment(repo_full_name, issue_number, comment_body)
  end

  def github_client(repo_full_name)
    private_pem = File.read(ENV['PRIVATE_KEY_PATH'])
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {
      iat: Time.now.to_i,
      exp: Time.now.to_i + (10 * 60),
      iss: ENV['APP_ID']
    }

    jwt = JWT.encode(payload, private_key, 'RS256')

    client = Octokit::Client.new(bearer_token: jwt)

    installation = client.find_repository_installation(repo_full_name)
    installation_id = installation.id

    token = client.create_app_installation_access_token(installation_id)[:token]

    Octokit::Client.new(access_token: token)
  end
end
