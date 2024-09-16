ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'rack/test'
require_relative '../app/app'

RSpec.describe 'Issue Estimate Reminder App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:payload) do
    {
      'action' => 'opened',
      'issue' => {
        'body' => issue_body,
        'number' => issue_number
      },
      'repository' => {
        'full_name' => repo_full_name
      }
    }
  end

  let(:issue_body) { 'This is a test issue.' }
  let(:issue_number) { 42 }
  let(:repo_full_name) { 'user/repo' }

  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_X_GITHUB_EVENT' => 'issues',
      'HTTP_X_HUB_SIGNATURE' => signature
    }
  end

  let(:secret) { 'test_secret' }
  let(:signature) do
    'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload.to_json)
  end

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('WEBHOOK_SECRET').and_return(secret)
    allow(Services::CreateIssueComment).to receive(:call)
  end

  it 'responds with 200 OK' do
    post '/', payload.to_json, headers
    expect(last_response.status).to eq(200)
  end

  it 'calls Services::CreateIssueComment when estimate is missing' do
    expect(Services::CreateIssueComment).to receive(:call).with(repo_full_name, issue_number, String)
    post '/', payload.to_json, headers
  end

  context 'when estimate is present in the issue body' do
    let(:issue_body) { 'Estimate: 3 days' }

    it 'does not call Services::CreateIssueComment' do
      expect(Services::CreateIssueComment).not_to receive(:call)
      post '/', payload.to_json, headers
    end
  end

  context 'when signature is invalid' do
    let(:signature) { 'invalid_signature' }

    it 'responds with 401 Unauthorized' do
      post '/', payload.to_json, headers
      expect(last_response.status).to eq(401)
    end
  end
end
