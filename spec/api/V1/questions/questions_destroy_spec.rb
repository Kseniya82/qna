require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token } }
  let!(:question) { create(:question, user: me) }

  describe 'DELETE /api/v1/questions/:id' do

    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it_behaves_like 'delete resource' do
        let(:resource) { Question }
      end
    end

    context 'user not author' do
      it_behaves_like 'not authorized user' do
        let(:user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }
        let(:request_params) { { access_token: access_token.token } }
      end
    end
  end
end
