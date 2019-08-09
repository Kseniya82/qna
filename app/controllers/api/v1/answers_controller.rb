class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @answers = question.answers
    render json: @answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
end
