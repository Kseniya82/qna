require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  let(:access_token) { create(:access_token) }
  let(:request_params) { {access_token: access_token.token, question: { body: 'question', title: 'Test question' } } }

  describe 'POST /api/v1/questions/' do

    let(:api_path) { "/api/v1/questions/" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }

      before { post api_path, params: request_params, headers: headers }

      it 'returns all public fields' do
        %w[title body].each do |attr|
          expect(question_response[attr]).to eq request_params[:question][attr.to_sym]
        end
      end
    end
  end
end
