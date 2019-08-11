require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token, body: 'Test edit answer' } }
  let!(:answer) { create(:answer, user: me) }

  describe 'PATCH /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'user add valid params' do
        before do
          patch api_path, params: request_params, headers: headers
        end
        let(:answer_response) { json['answer'] }

        it 'change body fields' do
          %w[body].each do |attr|
            expect(answer_response[attr]).to eq request_params[attr.to_sym]
          end
        end
      end

      context 'user add invalid params' do
        let(:request_params) { { access_token: access_token.token, body: nil } }
        let(:answer_response) { json['answer'] }
        before do
          patch api_path, params: request_params, headers: headers
        end

        it 'returns :unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'returns error message' do
          expect(json['errors']).to be_truthy
        end
      end
    end

    context 'user not author' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:request_params) { { access_token: access_token.token, body: 'edit answer', title: 'Test edit answer' } }
      before do
        patch api_path, params: request_params, headers: headers
      end
      it 'user mot autorize for update' do
        expect(response.body).to eq "You are not authorized to access this page."
      end
    end
  end
end
