class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy best]
  after_action :publish_answer, only: :create

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if can? :destroy, @answer
      @answer.destroy
    else
      redirect_to question_path(@answer.question), alert: 'Access denided'
    end
  end

  def update
    if can? :update, @answer
      @answer.update(answer_params)
      @question = @answer.question
    else
      redirect_to question_path(@answer.question), alert: 'Access denided'
    end
  end

  def best
    @question = @answer.question
    if can? :best, @answer
      @answer.best!
    else
      redirect_to question_path(@question), alert: 'Access denided'
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}/answers",
      answer: @answer,
      author_id: @answer.user_id,
      links: links_data,
      files: files_data
      )
  end

  def links_data
    @answer.links.each_with_object([]) do |link, links|
      if link.gist_url?
        GistService.new(link).content.each do |gist|
          links << { name: gist[:file_name], url: gist[:file_content] }
        end
      else
        links << { name: link.name, url: link.url }
      end
    end
  end

  def files_data
    @answer.files.each_with_object([]) do |file, files|
      files << { url: url_for(file), name: file.filename.to_s }
    end
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
      links_attributes: [:name, :url, :_destroy, :id])
  end
end
