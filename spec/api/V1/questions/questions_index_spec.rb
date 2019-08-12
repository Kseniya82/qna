require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json' } }

  let(:access_token) { create(:access_token) }
  let(:request_params) { { access_token: access_token.token } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }

      it_behaves_like 'return list resource with public fields' do
        before { get api_path, params: request_params, headers: headers }

        let(:list_resource_response) { json['questions'] }
        let(:resource_response) { json['questions'].first }
        let(:fields) { %w[id title body created_at updated_at user_id] }
        let(:resource_count) { 2 }
        let(:resource) { questions.first }
      end
    end
  end
end
