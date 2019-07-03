class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user
  validates :user, uniqueness: { scope: :votable , message: 'User cannot vote twice' }
  validate :validate_user_not_author

  VOTE_VALUE = { plus: 1, minus: -1 }.freeze

  def vote_up
    update!(value: VOTE_VALUE[:plus])
  end

  def vote_down
    update!(value: VOTE_VALUE[:minus])
  end

  private

  def validate_user_not_author
    errors.add(:user, message: "User can't vote for your own #{votable_type}") if user&.author?(votable)
  end

end
