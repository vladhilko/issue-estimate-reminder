require 'sinatra'
require 'json'
require 'dotenv/load'
require 'pry'

set :port, 3000

post '/' do
  request.body.rewind
  payload_body = request.body.read

  verify_signature(payload_body, request.env['HTTP_X_HUB_SIGNATURE'])

  event = JSON.parse(payload_body)

  status 200
end

helpers do
  def verify_signature(payload_body, signature)
    secret = ENV['WEBHOOK_SECRET']
    sha1 = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload_body)
    halt 401, "Signatures didn't match!" unless Rack::Utils.secure_compare(sha1, signature)
  end
end
