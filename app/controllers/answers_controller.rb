class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @answer = question.answers.new(answers_params)
    if @answer.save
      redirect_to question_path(@answer.question), notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end
