require 'rails_helper'
describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => 'application/json',
                "ACCEPT" => 'application/json' } }

  describe 'GET api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create("access_token", resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token} ,headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end
      it 'return all public fields' do
        %w[id admin email created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end
      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end
  #
    context 'authorized' do
      let!(:users) { create_list(:user ,2) }
      let(:me) { create(:user) }
      let(:access_token) { create("access_token", resource_owner_id: me.id) }
      let(:user_response) { json['users'].first }

      before { get '/api/v1/profiles', params: { access_token: access_token.token} ,headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id admin email created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq users.first.send(attr).as_json
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
