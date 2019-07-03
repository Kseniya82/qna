module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down vote_destroy]
    before_action :set_vote, only: %i[vote_up vote_down vote_destroy]

    rescue_from ActiveRecord::RecordInvalid, with: :render_errors
  end

  def vote_up
    if @vote.vote_up
      render_rating
    else
      render_errors
    end
  end

  def vote_down
    if @vote.vote_down
      render_rating
    else
      render_errors
    end
  end

  def vote_destroy
    @vote.destroy if current_user.author?(@vote)
    render_rating
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def set_vote
    @vote = current_user.votes.find_by(votable: @votable) || Vote.new(user: current_user, votable: @votable)
  end

  def render_rating
    respond_to do |format|
      format.json do
        render json:
          { resource: @votable.class.name.downcase,
            resourceId: @votable.id,
            rating: @vote.votable.rating }
      end
    end
  end

  def render_errors
    respond_to do |format|
      format.json do
        render json: @vote.errors, status: :unprocessable_entity
      end
    end
  end

end
