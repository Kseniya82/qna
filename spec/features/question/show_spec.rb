require 'rails_helper'

feature 'User can show a question with list of answer', %q{
  To see all suggested answers to the question
  As an any user
  I'd like to be able to look the list of answer on the question page
} do
  given(:user) {create(:user)}
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answers) { create_list(:answer, 3, question_id: question.id, user_id: user.id) }

  scenario 'User show question with list of answers' do
  #  visit root_path
  #  click_on 'Log out'
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content question.title

    answers.each do |a|
      expect(page).to have_content a.body
    end
  end
end
