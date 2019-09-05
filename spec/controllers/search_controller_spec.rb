require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #results' do
    let!(:questions) { create_list(:question, 3) }
    let!(:service) { Services::Search.new }
    context 'with valid attributes' do
      Services::Search::ALLOW_SCOPES.each do |scope|
        before do
          allow(Services::Search).to receive(:new).and_return(service)
          expect(service).to receive(:call).and_return(questions)
          get :results, params: { query: questions.sample.title, scope: scope }
        end

        it "#{scope} return OK" do
          expect(response).to be_successful
        end

        it "renders #{scope} results view" do
          expect(response).to render_template :results
        end

        it "#{scope} assign Services::Search.new.call to @results" do
          expect(assigns(:results)).to eq questions
        end
      end
    end

    context 'with invalid params' do
      before do
        get :results, params: { query: questions.sample.title, scope: 'file' }
      end
      it 'return status 400' do
        expect(response.status).to eq 400
      end
    end
  end
end
