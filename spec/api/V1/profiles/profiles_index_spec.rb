require 'rails_helper'
describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => 'application/json',
                "ACCEPT" => 'application/json' } }

  let(:me) { create(:user) }
  let(:access_token) { create("access_token", resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token } }

  describe 'GET api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end
  #
    context 'authorized' do
      let!(:users) { create_list(:user ,2) }
      let(:user) { users.first}
      let(:user_response) { json['users'].first }

      before { get api_path, params: request_params ,headers: headers }

      it 'return all public fields' do
        %w[id admin email created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end

      it 'does not return me' do
        expect(json['users']).to_not be_include(me)
      end
    end
  end
end
