require 'rails_helper'

describe 'answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json' } }

  let(:access_token) { create(:access_token) }
  let(:request_params) { { access_token: access_token.token } }
  let!(:question) { create(:question) }

  describe 'GET /api/v1/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      it_behaves_like 'return list resource with public fields' do
        before { get api_path, params: request_params, headers: headers }

        let(:list_resource_response) { json['answers'] }
        let(:resource_response) { json['answers'].first }
        let(:fields) { %w[id body created_at updated_at user_id] }
        let(:resource_count) { 2 }
        let(:resource) { answers.first }
      end
    end
  end
end
