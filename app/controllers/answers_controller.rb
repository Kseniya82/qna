class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy]

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    unless current_user.author?(@answer)
      return redirect_to question_path(@answer.question), alert: 'Access denided'
    end

    @answer.destroy
  end

  def update

    @answer.update(answer_params)
    @question = @answer.question
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
