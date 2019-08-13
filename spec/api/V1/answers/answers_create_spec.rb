require 'rails_helper'

describe 'answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token, body: 'answer' } }
  let!(:question) { create(:question) }

  describe 'POST /api/v1/questions/:question_id/answers/' do

    let(:api_path) { "/api/v1//questions/#{question.id}/answers/" }
    let(:method) { :post }
    let(:resource) { Answer }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'user add valid params' do
        before do
          post api_path, params: request_params, headers: headers
        end
        let(:answr_response) { json['answrr'] }

        it_behaves_like 'created resource' do
          let(:resource_response) { json['answer'] }
          let(:fields) { %w[body] }
        end
      end

      context 'user add invalid params' do
        it_behaves_like 'try created resource with invalid params' do
          let(:request_params) { { access_token: access_token.token, body: nil} }
        end
      end
    end
  end
end
