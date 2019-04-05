require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new answer in database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
        .to change(question.answers, :count).by(1)
      end
      it 'redirects to show question view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it ' not save a new answer in database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }
        .to_not change(Answer, :count)
      end

      it 're-render to show question view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

end
