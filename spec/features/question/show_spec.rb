require 'rails_helper'

feature 'User can show a question with list of answer', %q{
  To see all suggested answers to the question
  As an any user
  I'd like to be able to look the list of answer on the question page
} do
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 3, question_id: question.id) }

  scenario 'User show question with list of answers' do
    visit question_path(question)
    answers.each do |a|
      fill_in 'Body', with: a.body
      click_on 'Add answer'
      expect(page).to have_content a.body
    end
    expect(page).to have_content question.body
    expect(page).to have_content question.title
  end
end
