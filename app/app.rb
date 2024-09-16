require 'sinatra'
require 'json'
require 'pry'

set :port, 3000

post '/' do
  request.body.rewind
  payload_body = request.body.read

  event = JSON.parse(payload_body)

  status 200
end
