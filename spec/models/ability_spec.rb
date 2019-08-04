require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question) }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer) }

    it { should be_able_to :best, create(:answer, question: create(:question, user: user)) }
    it { should_not be_able_to :best, create(:answer) }

    context 'questions attachment' do
      let(:question) { create(:question, user: user) }
      let(:question2) { create(:question) }
      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        question2.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end

      it { should be_able_to :create, question.files.new }
      it { should be_able_to :destroy, question.files.last }
      it { should_not be_able_to :create, question2.files.new }
      it { should_not be_able_to :destroy, question2.files.last }
    end

    context 'answers attachment' do
      let(:answer) { create(:answer, user: user) }
      let(:answer2) { create(:answer) }
      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        answer2.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end

      it { should be_able_to :create, answer.files.new }
      it { should be_able_to :destroy, answer.files.last }
      it { should_not be_able_to :create, answer2.files.new }
      it { should_not be_able_to :destroy, answer2.files.last }
    end

    context 'voting' do
      it { should_not be_able_to :vote_up, create(:answer, user: user) }
      it { should be_able_to :vote_up, create(:answer) }
      it { should_not be_able_to :vote_down, create(:answer, user: user) }
      it { should be_able_to :vote_down, create(:answer) }


      it { should_not be_able_to :vote_up, create(:question, user: user) }
      it { should be_able_to :vote_up, create(:question) }
      it { should_not be_able_to :vote_down, create(:question, user: user) }
      it { should be_able_to :vote_down, create(:question) }

    end

    context 'vote destroy question' do
      let!(:question) { create(:question) }
      let!(:question2) { create(:question) }
      let!(:user_vote) { create(:vote, user: user, votable: question) }
      let!(:not_user_vote) { create(:vote, votable: question2) }
      it { should be_able_to :vote_destroy, question }
      it { should_not be_able_to :vote_destroy, question2 }
    end

    context 'vote destroy answer' do
      let!(:answer) { create(:answer) }
      let!(:answer2) { create(:answer) }
      let!(:user_vote) { create(:vote, user: user, votable: answer) }
      let!(:not_user_vote) { create(:vote, votable: answer2) }
      it { should be_able_to :vote_destroy, answer }
      it { should_not be_able_to :vote_destroy, answer2 }
    end

    context 'links' do
      let(:question) { create(:question, user: user) }
      let(:question2) { create(:question) }
      it { should be_able_to :create, question.links.new }
      it { should_not be_able_to :create, question2.links.new }
    end

    context 'award' do
      let(:question) { create(:question, user: user) }
      let(:question2) { create(:question) }
      it { should be_able_to :create, create(:award, question: question ) }
      it { should_not be_able_to :create, create(:award, question: question2 ) }
    end
  end
end
