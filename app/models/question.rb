class Question < ApplicationRecord

  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :body, :title, presence: true

  after_create :subscribe_to_answers

  private

  def subscribe_to_answers
    subscriptions.create(user: user)
  end
end
