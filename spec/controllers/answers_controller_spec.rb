require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    let(:answer) { create(:answer, question_id: question) }

    before { get :new, params: { question_id: question } }

    it 'assigns a new Answers to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
end
