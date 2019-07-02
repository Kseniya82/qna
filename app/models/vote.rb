class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user
  validates :user, uniqueness: { scope: :votable }

  VOTE_VALUE = { plus: 1, minus: -1 }.freeze

  def vote_up
    update!(value: VOTE_VALUE[:plus])
  end

  def vote_down
    update!(value: VOTE_VALUE[:minus])
  end
end
