class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: Date.today)

    mail to: user.email
  end
end
