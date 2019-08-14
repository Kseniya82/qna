require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  let(:answer) { create(:answer) }
  let(:question) { answer.question }
  let(:user) { question.user }
  let(:mail) { NewAnswerMailer.notification(answer) }

  it "renders the headers" do
    expect(mail.subject).to eq "QNA notification: new answer"
    expect(mail.to).to eq [user.email]
    expect(mail.from).to eq(["from@example.com"])
  end

  it "renders answer body" do
    expect(mail.body.encoded).to match(answer.body)
  end
end
