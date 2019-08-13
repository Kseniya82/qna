require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json' } }

  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }
  let(:request_params) { { access_token: access_token.token } }

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
        answer.links.create!(name: 'google', url: 'https://www.google.com')
        answer.links.create!(name: 'gist', url: 'https://gist.github.com/Kseniya82/a84079fda58dc44e8a8165063e3715a3')
      end

      before { get api_path, params: request_params, headers: headers }

      it_behaves_like 'return resource with public fields' do
        let(:resource_response) { answer_response }
        let(:resource) { answer }
        let(:fields) { %w[id body created_at updated_at user_id] }
      end

      describe 'comments' do
        it_behaves_like 'return list resource with public fields' do
          let(:list_resource_response) { answer_response['comments'] }
          let(:resource_response) { answer_response['comments'].first }
          let(:resource) { Comment.where(id: resource_response['id']).first }
          let(:resource_count) { 3 }
          let(:fields) { %w[id body user_id created_at updated_at] }
        end
      end

      describe 'files' do
        let(:file_response) { answer_response['files'].first }
        let(:file) { answer.files.first }

        it 'returns list of files' do
          expect(answer_response['files'].size).to eq 2
        end

        it 'returns files url' do
          expect(file_response).to eq rails_blob_path(file, only_path: true)
        end
      end

      describe 'links' do
        it_behaves_like 'return list resource with public fields' do
          let(:list_resource_response) { answer_response['links'] }
          let(:resource_response) { answer_response['links'].first }
          let(:resource) { Link.where(id: resource_response['id']).first }
          let(:resource_count) { 2 }
          let(:fields) { %w[id name url] }
        end
      end
    end
  end
end
