require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token, body: 'question', title: 'Test question' } }

  describe 'POST /api/v1/questions/' do

    let(:api_path) { "/api/v1/questions/" }
    let(:method) { :post }
    let(:resource) { Question }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'user add valid params' do
        before do
          post api_path, params: request_params, headers: headers
        end
        let(:question_response) { json['question'] }

        it_behaves_like 'created resource' do
          let(:resource_response) { json['question'] }
          let(:fields) { %w[title body] }
        end
      end

      context 'user add invalid params' do
        it_behaves_like 'try created resource with invalid params' do
          let(:request_params) { { access_token: access_token.token, body: nil, title: nil} }
        end
      end
    end
  end
end
