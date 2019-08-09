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
      let(:question_response) { json['questions'].first }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns list of questions' do

        expect(json['questions'].size).to eq 2
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
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
        question.links.create!(name: 'google', url: 'https://www.google.com')
        question.links.create!(name: 'gist', url: 'https://gist.github.com/Kseniya82/a84079fda58dc44e8a8165063e3715a3')
      end

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id title body created_at updated_at user_id].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment_response) { question_response['comments'].first }
        let(:comment) { Comment.where(id: comment_response['id']).first }


        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file_response) { question_response['files'].first }
        let(:file) { question.files.first }

        it 'returns list of files' do
          expect(question_response['files'].size).to eq 2
        end

        it 'returns files url' do
          expect(file_response).to eq rails_blob_path(file, only_path: true)
        end
      end

      describe 'links' do
        let(:link_response) { question_response['links'].first }
        let(:link) { Link.where(id: link_response['id']).first }


        it 'returns list of links' do
          expect(question_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id name url].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end
    end
  end
end
