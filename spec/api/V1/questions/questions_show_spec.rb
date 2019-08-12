require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json' } }

  let(:access_token) { create(:access_token) }
  let(:request_params) { { access_token: access_token.token } }

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

      before { get api_path, params: request_params, headers: headers }

      it_behaves_like 'return resource with public fields' do
        let(:resource_response) { question_response }
        let(:fields) { %w[id title body created_at updated_at user_id] }
        let(:resource) { question }
      end

      describe 'comments' do
        it_behaves_like 'return list resource with public fields' do
          let(:list_resource_response) { question_response['comments'] }
          let(:resource_response) { question_response['comments'].first }
          let(:resource) { Comment.where(id: resource_response['id']).first }
          let(:resource_count) { 3 }
          let(:fields) { %w[id body user_id created_at updated_at] }
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
        it_behaves_like 'return list resource with public fields' do
          let(:list_resource_response) { question_response['links'] }
          let(:resource_response) { question_response['links'].first }
          let(:resource) { Link.where(id: resource_response['id']).first }
          let(:resource_count) { 2 }
          let(:fields) { %w[id name url] }
        end
      end
    end
  end
end
