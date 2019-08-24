require 'rails_helper'

RSpec.describe Services::Subscription do
  let!(:users) { create_list(:user, 3) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, user: users[0], question:question) }


  it 'sends subscriptions to users subscribe' do
    Subscription.find_each do |sub|
      expect(SubscriptionMailer).to receive(:notification).with(sub.user, answer).and_call_original
    end


    subject.call(answer)
  end

  it 'not send subscription to users not have subscribe' do
    expect(SubscriptionMailer).to_not receive(:notification).with(users[2], answer)
  end
end
