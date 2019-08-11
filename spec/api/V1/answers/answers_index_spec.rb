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
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before {get api_path, params: request_params, headers: headers}

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at user_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end
end