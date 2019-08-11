require 'rails_helper'

describe 'answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token, body: 'answer' } }
  let!(:question) { create(:question) }

  describe 'POST /api/v1/questions/:question_id/answers/' do

    let(:api_path) { "/api/v1//questions/#{question.id}/answers/" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'user add valid params' do
        before do
          post api_path, params: request_params, headers: headers
        end
        let(:answer_response) { json['answer'] }

        it 'save a new answer in database' do
          expect(Answer.count).to eq 1
        end
        it 'returns all public fields' do
          %w[body].each do |attr|
            expect(answer_response[attr]).to eq request_params[attr.to_sym]
          end
        end
        it 'return me as author answer' do
          expect(answer_response['user_id']).to eq me.id
        end
      end

      context 'user add invalid params' do
        let(:request_params) { { access_token: access_token.token, body: nil } }

        before do
          post api_path, params: request_params, headers: headers
        end
        it 'does not saves a new answer in the database' do
          expect(Answer.count).to eq 0
        end

        it 'returns :unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'returns error message' do
          expect(json['errors']).to be_truthy
        end
      end
    end
  end
end
