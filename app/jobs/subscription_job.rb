class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswer.new.call(answer)
  end
end
