require 'rails_helper'

feature 'User can show list of question', %q{
  In order to find similar problem
  As an any user
  I'd like to be able to look the list of questions
} do
  
  scenario 'User show list of questions' do
    questions = Question.all

    visit questions_path
    questions.all? do |q|
      expect(page).to have_content q.title
    end
  end
end
