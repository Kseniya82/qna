class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy best]

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
    unless current_user.author?(@answer)
      return redirect_to question_path(@answer.question), alert: 'Access denided'
    end

    @answer.update(answer_params)
    @question = @answer.question
  end

  def best
    @question = @answer.question
    unless current_user.author?(@question)
      return redirect_to question_path(@question), alert: 'Access denided'
    end

    @answer.best!
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
