require 'rails_helper'

RSpec.shared_examples 'voted' do
  let!(:user) { create(:user) }
  let!(:model) { create(described_class.controller_name.classify.downcase.to_sym) }

  describe 'POST #vote_up' do
    context 'with valid attributes' do
      before { login(user) }
      it 'saves a new vote in the database' do
        expect { post :vote_up, params: { id: model }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'render json' do
        post :vote_up, params: { id: model }, format: :json
        json_response = { "resource" => model.class.name.downcase,
                          "resourceId" => model.id,
                          "rating" => Vote::VOTE_VALUE[:plus] }

        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to eq json_response
      end
    end

    context 'with invalid attributes' do
      before { login(model.user) }
      it 'not saves a new vote in the database' do
        expect { post :vote_up, params: { id: model }, format: :json }.to_not change(Vote, :count)
      end

      it 'render json' do
        post :vote_up, params: { id: model }, format: :json
        json_response = {"user"=>[{"message"=>"User can't vote for your own #{model.class.name}"}]}

        expect(response).to have_http_status :unprocessable_entity
        expect(JSON.parse(response.body)).to eq json_response
      end
    end
  end

  describe 'POST #vote_down' do
    context 'with valid attributes' do
      before { login(user) }
      it 'saves a new vote in the database' do
        expect { post :vote_down, params: { id: model }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'render json' do
        post :vote_down, params: { id: model }, format: :json
        json_response = { "resource" => model.class.name.downcase,
                          "resourceId" => model.id,
                          "rating" => Vote::VOTE_VALUE[:minus] }

        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to eq json_response
      end
    end

    context 'with invalid attributes' do
      before { login(model.user) }
      it 'not saves a new vote in the database' do
        expect { post :vote_down, params: { id: model }, format: :json }.to_not change(Vote, :count)
      end

      it 'render json' do
        post :vote_down, params: { id: model }, format: :json
        json_response = { "user"=>[{ "message"=>"User can't vote for your own #{model.class.name}" }] }

        expect(response).to have_http_status :unprocessable_entity
        expect(JSON.parse(response.body)).to eq json_response
      end
    end
  end

  describe 'DELETE #vote_destroy' do
    before { login(user) }
    let!(:vote) { create(:vote, votable: model, user: user)}
    it 'delete vote from the database' do
      expect { delete :vote_destroy, params: { id: model }, format: :json }.to change(Vote, :count).by(-1)
    end

    it 'render json' do
      delete :vote_destroy, params: { id: model }, format: :json
      json_response = { "resource" => model.class.name.downcase,
                        "resourceId" => model.id,
                        "rating" => 0 }

      expect(response).to have_http_status :ok
      expect(JSON.parse(response.body)).to eq json_response
    end
  end
end
