class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::Subscription.new.send_subscription(answer)
  end
end
