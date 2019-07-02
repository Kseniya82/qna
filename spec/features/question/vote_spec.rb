require 'rails_helper'

feature 'Authenticated user may voted for question', %q{
  In order to to allocate the pleasant question
  As an authenticated user
  I'd like to be able to vote for a question
}, js:true do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Notauthenticated user not may voted' do
    visit question_path(question)

    expect(page).to_not have_link "Vote up"
    expect(page).to_not have_link "Vote down"
  end

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'may voted uo' do
      click_on 'Vote up'

      expect(page).to have_content '1'
    end

    scenario 'may voted down' do
      click_on 'Vote down'

      expect(page).to have_content '-1'
    end
  end
end
