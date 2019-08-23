class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::Subscription.new.call(answer)
  end
end
