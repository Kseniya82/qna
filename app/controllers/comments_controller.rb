class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: comment_json_data
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_commentable
    id = params["#{model_klass.to_s.downcase}_id"]
    @commentable = model_klass.find(id)
  end

  def model_klass
    params['question_id'].nil? ? Answer : Question
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.present?

    ActionCable.server.broadcast "question/#{question_id}/comments", comment_json_data
  end

  def question_id
    if @commentable.is_a? Answer
      @commentable.question_id
    else
      @commentable.id
    end
  end

  def comment_json_data
    { resource: @commentable.class.name.downcase,
      resource_id: @commentable.id,
      id: @comment.id,
      author_id: @comment.user_id,
      body: @comment.body }
  end
end
