require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json' } }

  let(:access_token) { create(:access_token) }
  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json.first }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns list of questions' do
        expect(json.size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at user_id].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }


    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      # let(:question_response) { json['question'] }
      let(:question_response) { json }
      let!(:comments) { create_list(:comment, 3, commentable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id title body created_at updated_at user_id].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      xdescribe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
      it 'return list files' do

      end
      it 'return list links' do

      end
    end
  end
end
