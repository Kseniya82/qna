class Services::Subscription
  def call(answer)
    answer.question.subscriptions.find_each do |subscription|
      SubscriptionMailer.notification(subscription.user, answer).deliver_later
   end
  end
end
