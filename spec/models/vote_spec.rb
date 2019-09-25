require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to(:votable).touch(true) }

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let!(:vote1) { create(:vote, votable: question, user: user) }

  it 'validate uniqueness user with scope votable' do
    vote2 = Vote.new(votable: question, user: user)
    expect(vote2).to_not be_valid
  end

  xit 'validate uniqueness user with scope votable'do
    expect(Vote.new(votable: question, user: user)).
      to validate_uniqueness_of(:user).
      scoped_to(:votable).
      with_message('User cannot vote twice')
  end

  it 'validate user not author votable' do
    vote2 = Vote.new(votable: question, user: question.user)
    expect(vote2).to_not be_valid
  end

  it 'vote up' do
    vote1.vote_up
    expect(vote1.value).to eq 1
  end

  it 'vote down' do
    vote1.vote_down
    expect(vote1.value).to eq(-1)
  end
end
