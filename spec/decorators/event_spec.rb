# frozen_string_literal: true

# spec/decorators/event_spec.rb
require 'spec_helper'
require_relative '../../app/decorators/event'

RSpec.describe Decorators::Event do
  subject(:event_decorator) { described_class.new(event_data) }

  let(:event_data) do
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

  describe '#issue_body' do
    context 'when issue body is present' do
      it 'returns the issue body' do
        expect(event_decorator.issue_body).to eq(issue_body)
      end
    end

    context 'when issue body is nil' do
      let(:issue_body) { nil }

      it 'returns an empty string' do
        expect(event_decorator.issue_body).to eq('')
      end
    end
  end

  describe '#issue_number' do
    it 'returns the issue number' do
      expect(event_decorator.issue_number).to eq(issue_number)
    end
  end

  describe '#repo_full_name' do
    it 'returns the repository full name' do
      expect(event_decorator.repo_full_name).to eq(repo_full_name)
    end
  end

  describe '#action' do
    it 'returns the action' do
      expect(event_decorator.action).to eq('opened')
    end
  end

  describe '#issue_opened?' do
    context 'when action is "opened"' do
      it 'returns true' do
        expect(event_decorator.issue_opened?).to be true
      end
    end

    context 'when action is not "opened"' do
      let(:event_data) { super().merge('action' => 'closed') }

      it 'returns false' do
        expect(event_decorator.issue_opened?).to be false
      end
    end
  end

  describe '#estimate_present?' do
    context 'when estimate is present in issue body' do
      let(:issue_body) { 'Estimate: 3 days' }

      it 'returns true' do
        expect(event_decorator.estimate_present?).to be true
      end
    end

    context 'when estimate is not present in issue body' do
      it 'returns false' do
        expect(event_decorator.estimate_present?).to be false
      end
    end

    context 'when estimate is present with different casing' do
      let(:issue_body) { 'estimate: 5 days' }

      it 'returns true' do
        expect(event_decorator.estimate_present?).to be true
      end
    end

    context 'when estimate is present with extra spaces' do
      let(:issue_body) { 'Estimate:    2   days' }

      it 'returns true' do
        expect(event_decorator.estimate_present?).to be true
      end
    end

    context 'when estimate is present with different wording' do
      let(:issue_body) { 'Estimated time: 4 days' }

      it 'returns false' do
        expect(event_decorator.estimate_present?).to be false
      end
    end
  end
end
