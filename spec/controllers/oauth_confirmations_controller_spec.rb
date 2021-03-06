require 'rails_helper'

RSpec.describe OauthConfirmationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #new' do

    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:email) { 'test@mail.com' }

    context 'with valid attributes' do
      it 'saves a new user in the database' do
        expect { post :create, params: { user: { email: email } } }.to change(User, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { user: { email: email } }

         expect(response).to render_template :create
      end
    end
  end

end
