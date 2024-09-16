require 'sinatra'
require 'json'
require 'openssl'
require 'jwt'
require 'octokit'
require 'dotenv/load'
require 'pry'

require_relative 'decorators/event'
require_relative 'services/create_issue_comment'

set :port, 3000

post '/' do
  request.body.rewind
  payload_body = request.body.read

  verify_signature(payload_body, request.env['HTTP_X_HUB_SIGNATURE'])

  event = Decorators::Event.new(JSON.parse(payload_body))

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
      post_comment(event)
    end
  end

  def post_comment(event)
    comment_body = "Please add an estimate to this issue in the format 'Estimate: X days'."
    Services::CreateIssueComment.call(event.repo_full_name, event.issue_number, comment_body)
  end

end
