require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  before { login(user) }

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'Author create question with valid attributes' do
      it 'save a new question in database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it ' not save question in database' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:own_question) { create(:question, user: user) }
    context 'Author tried delete question' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: own_question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: own_question }
        expect(response).to redirect_to questions_path
      end
    end
    context ' Not author tried delete question' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to root path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index}

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question) }
    let!(:own_question) { create(:question, user: user) }

    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: own_question, question: { body: 'new body' } }, format: :js
        own_question.reload
        expect(own_question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: own_question, question: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: own_question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(own_question, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: own_question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
    context 'Not author tried update question' do
      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        end.to_not change(question, :body)
      end

      it 'response have forbidden status' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
