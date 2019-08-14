class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerMailer.notification(answer).deliver_later
  end
end
