class NewAnswerMailer < ApplicationMailer
  def notification(answer)
    @question = answer.question
    user = @question.user
    @answer = answer

    mail to: user.email,
         subject: "QNA notification: new answer"
  end
end
