require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token, body: 'Test edit answer' } }
  let!(:answer) { create(:answer, user: me) }

  describe 'PATCH /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'user add valid params' do
        before do
          patch api_path, params: request_params, headers: headers
        end

        it_behaves_like 'updated resource' do
          let(:resource_response) { json['answer'] }
          let(:fields) { %w[body] }
        end
      end

      context 'user add invalid params' do
        let(:request_params) { { access_token: access_token.token, body: nil } }
        it_behaves_like 'try update resource with invalid params'
      end
    end

    context 'user not author' do
      it_behaves_like 'not authorized user' do
        let(:user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }
        let(:request_params) { { access_token: access_token.token } }
      end
    end
  end
end
