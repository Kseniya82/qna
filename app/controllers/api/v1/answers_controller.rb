class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer
  before_action :set_answer, only: %i[show update destroy]
  after_action :publish_answer, only: :create

  def index
    @answers = question.answers
    authorize! :index, @answers
    render json: @answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    authorize! :show, @answer
    render json: @answer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    @answer = Answer.find(params[:id])
    authorize! :update, @answer
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    authorize! :destroy, @answer
    @answer.destroy!
    render json: {}, status: :ok
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.permit(:body)
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}/answers",
      answer: @answer,
      author_id: @answer.user_id,
      links: [],
      files: []
      )
  end


  def question
    @question ||= Question.find(params[:question_id])
  end
end
