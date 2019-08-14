class Answer < ApplicationRecord

  include Votable
  include Commentable

  default_scope { order(best: :desc) }

  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_create :sent_notification

  def best!
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end

  private

  def sent_notification
    NewAnswerJob.perform_later(self)
    SubscriptionJob.perform_later(self)
  end
end
