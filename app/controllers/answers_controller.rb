class AnswersController < ApplicationController
  def new
    @answer = question.answers.new
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
end
