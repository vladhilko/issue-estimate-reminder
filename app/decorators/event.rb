module Decorators
  class Event
    attr_reader :event

    def initialize(event)
      @event = event
    end

    def issue_body
      event['issue']['body'] || ''
    end

    def issue_number
      event['issue']['number']
    end

    def repo_full_name
      event['repository']['full_name']
    end

    def action
      event['action']
    end

    def issue_opened?
      action == 'opened'
    end

    def estimate_present?
      issue_body.match?(/Estimate:\s*\d+\s*days/i)
    end
  end
end
