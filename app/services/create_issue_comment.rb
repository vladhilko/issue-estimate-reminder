# frozen_string_literal: true

module Services
  class CreateIssueComment
    def self.call(repo_full_name, issue_number, comment_body)
      new(repo_full_name, issue_number, comment_body).call
    end

    def initialize(repo_full_name, issue_number, comment_body)
      @repo_full_name = repo_full_name
      @issue_number = issue_number
      @comment_body = comment_body
    end

    def call
      github_client.add_comment(repo_full_name, issue_number, comment_body)
    end

    private

    attr_reader :repo_full_name, :issue_number, :comment_body

    def github_client # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      private_pem = File.read(ENV.fetch('PRIVATE_KEY_PATH', nil))
      private_key = OpenSSL::PKey::RSA.new(private_pem)

      payload = {
        iat: Time.now.to_i,
        exp: Time.now.to_i + (10 * 60),
        iss: ENV.fetch('APP_ID', nil)
      }

      jwt = JWT.encode(payload, private_key, 'RS256')

      client = Octokit::Client.new(bearer_token: jwt)

      installation = client.find_repository_installation(repo_full_name)

      token = client.create_app_installation_access_token(installation.id)[:token]

      Octokit::Client.new(access_token: token)
    end
  end
end
