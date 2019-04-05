require 'rails_helper'

feature 'User can create new answer on page question', %q{
  In order to create new answer
  As an any user
  I'd like to be able to write the answer on page question
} do
  given(:question) { create(:question) }
  scenario 'User write answer ' do
    visit question_path(question)
    fill_in 'answer_body', with: 'Answer body'
    click_on 'Add answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Answer body'
  end
  scenario 'User write answer with errors' do
    visit question_path(question)
    click_on 'Add answer'

    expect(page).to have_content "Body can't be blank"
  end
end
