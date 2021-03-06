class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: %i[show update destroy]
  after_action :publish_question, only: %i[create]

  authorize_resource

  def new
    @question = current_user.questions.new
    @question.build_award
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def update
    @question.update(question_params)
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
      files: [],
      award_attributes: [:title, :image],
      links_attributes: [:name, :url, :_destroy, :id])
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
