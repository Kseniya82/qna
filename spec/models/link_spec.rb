require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should_not allow_values('33.com', '', nil).for(:url) }

  context 'test links as gist url' do
    let(:question) { create(:question) }
    let(:gist_url) { 'https://gist.github.com/Kseniya82/a84079fda58dc44e8a8165063e3715a3' }
    let(:gist_link) { question.links.create!(name:'Gist link', url: gist_url) }
    let(:not_gist_link) { question.links.create!(name:'Google link', url: 'https://google.com') }

    it 'gist link is gist?' do
      expect(gist_link).to be_gist_url
    end

    it 'not gist link is gist?' do
      expect(not_gist_link).to_not be_gist_url
    end
  end
end
