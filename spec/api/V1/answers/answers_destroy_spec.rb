require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token } }
  let!(:answer) { create(:answer, user: me) }

  describe 'DELETE /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it_behaves_like 'delete resource' do
        let(:resource) { Answer }
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
