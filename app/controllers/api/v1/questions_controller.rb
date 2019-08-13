class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question
  before_action :set_question, only: %i[show update destroy]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy!
    render json: {}, status: :ok
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.permit(:title, :body)
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
