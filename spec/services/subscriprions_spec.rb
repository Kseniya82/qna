require 'rails_helper'

RSpec.describe Services::Subscription do
  let!(:users) { create_list(:user, 3) }
  let!(:question) { create(:question, user: users[2]) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscriptions[0]) { create(:subscription, user: users[0], question: question) }
  let!(:subscriptions[1]) { create(:subscription, user: users[1], question: question) }
  let(:not_subscribe_user) { create(:user) }

  it 'sends subscriptions to users subscribe' do
    users.reverse.each do |user|
      expect(SubscriptionMailer).to receive(:notification).with(user, answer).and_call_original
    end
    subject.call(answer)
  end

  it 'not send subscription to users not have subscribe' do
    expect(SubscriptionMailer).to_not receive(:notification).with(not_subscribe_user, answer)
  end
end
