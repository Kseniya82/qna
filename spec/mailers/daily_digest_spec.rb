require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create :user }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:questions) { create_list :question, 3, created_at: Date.today }

    it "renders the headers" do
      expect(mail.subject).to eq "Daily questions digest from QNA"
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders today's question title" do
      expect(mail.body.encoded).to match(questions.last.title)
    end
  end
end
