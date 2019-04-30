require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new answer in database increment users answers' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
        .to change(user.answers, :count).by(1)
      end

      it 'save a new answer in database increment parent question answers' do
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

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    let!(:own_answer) { create(:answer, user: user)}
    context 'Author tried delete question' do
      it 'deletes the answer from  answers' do
        expect { delete :destroy, params: { id: own_answer} }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        delete :destroy, params:  { id: own_answer }
        expect(response).to redirect_to question_path(own_answer.question)
      end
    end

    context ' Not author tried delete answer' do
      it 'no deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }
    let!(:own_answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: own_answer, answer: { body: 'new body' } }, format: :js
        own_answer.reload
        expect(own_answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: own_answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: own_answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(own_answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: own_answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
    context 'Not author tried update answer' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end
end
