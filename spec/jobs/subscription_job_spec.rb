require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do
  let(:service) { double('Service::Subscription') }
  let(:answer) { create(:answer) }

  before do
    allow(Services::Subscription).to receive(:new).and_return(service)
  end

  it 'calls Service::Subscription#send_subscription' do
    expect(service).to receive(:call)
    SubscriptionJob.perform_now(answer)
  end
end
