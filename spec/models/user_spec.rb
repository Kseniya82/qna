require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user_id: users.first.id) }
  let(:answer) { create(:answer, user_id: users.first.id, question_id: question.id) }

  it 'Author question' do
    expect(users.first.author?(question)).to be_truthy
  end

  it 'Author answer' do
    expect(users.first.author?(answer)).to be_truthy
  end

  it 'Not author question' do
    expect(users.last.author?(question)).to be_falsey
  end

  it 'Not author answer' do
    expect(users.last.author?(answer)).to be_falsey
  end
end
