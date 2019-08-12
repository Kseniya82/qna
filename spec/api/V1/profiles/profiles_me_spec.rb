require 'rails_helper'
describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => 'application/json',
                "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create("access_token", resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token } }
  describe 'GET api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: request_params ,headers: headers }

      it_behaves_like 'return resource with public fields' do
        let(:resource_response) { json['user'] }
        let(:resource) { me }
        let(:fields) { %w[id admin email created_at updated_at] }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end
end
