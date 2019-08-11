require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token } }
  let!(:answer) { create(:answer, user: me) }

  describe 'DELETE /api/v1/answers/:id' do

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      before do
        delete api_path, params: request_params, headers: headers
      end
      # let(:answer_response) { json['answer'] }

      it 'return empty response body' do
        expect(response.body).to eq '{}'
      end

      it 'does delete a answer from the database' do
        expect(Answer.count).to eq 0
      end
    end

    context 'user not author' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:request_params) { { access_token: access_token.token } }
      before do
        delete api_path, params: request_params, headers: headers
      end
      it 'user mot autorize for destroy' do
        expect(response.body).to eq "You are not authorized to access this page."
      end
    end
  end
end
