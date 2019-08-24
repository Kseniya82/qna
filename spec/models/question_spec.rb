require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
