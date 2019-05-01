require 'rails_helper'

feature 'Only authenticated user can create new answer on page question', %q{
  In order to create new answer
  As an authenticated user
  I'd like to be able to write the answer on page question
} do

  given(:user) {create(:user)}
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'write answer' do
      visit question_path(question)
      fill_in 'answer_body', with: 'Answer body'
      click_on 'Add answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer body'
      end
    end

    scenario 'write answer with errors' do
      visit question_path(question)
      click_on 'Add answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to add a answer' do
    visit question_path(question)
    click_on 'Add answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
