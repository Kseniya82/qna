require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answer2) { create(:answer, question: question) }

  it 'mark answer as best' do
    answer.best!
    expect(answer).to be_best
  end

  it 'Best answer may be only one' do
    answer.best!
    answer2.best!
    answer.reload
    expect(answer).to_not be_best
  end

  it 'Best answer on the first place' do
    answer2.best!
    expect(Answer.first).to eq(answer2)
  end
end
