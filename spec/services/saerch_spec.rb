require 'rails_helper'

RSpec.describe Services::Search do
  Services::Search::ALLOW_SCOPES.each do |scope|
    it "calls search from #{scope} class" do
      expect(scope.classify.constantize).to receive(:search).with('test')
      Services::Search.new.call(query: 'test', scope: scope)
    end
  end
end
