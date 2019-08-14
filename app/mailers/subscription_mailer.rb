class SubscriptionMailer < ApplicationMailer
  def notification(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email,
         subject: "QNA subscription: new answer"
  end
end
