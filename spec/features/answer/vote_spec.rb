require 'rails_helper'

feature 'Authenticated user may voted for answer', %q{
  In order to to allocate the pleasant answer
  As an authenticated user
  I'd like to be able to vote for a answer
}, js:true do

  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }

  scenario 'Notauthenticated user not may voted' do
    visit question_path(answer.question)
    within '.answers' do
      expect(page).to_not have_link "Vote up"
      expect(page).to_not have_link "Vote down"
    end
  end

  scenario 'author cannot voted for own questio' do
    sign_in(answer.user)
    visit question_path(answer.question)
    within '.answers' do
      expect(page).to_not have_link "Vote up"
      expect(page).to_not have_link "Vote down"
    end
  end

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(answer.question)
    end
    scenario 'may voted uo' do
      within '.answers' do
        click_on 'Vote up'

        expect(page).to have_content '1'
      end
    end

    scenario 'may voted down' do
      within '.answers' do
        click_on 'Vote down'

        expect(page).to have_content '-1'
      end
    end

    scenario 'cannot voted twice' do
      within '.answers' do
        click_on 'Vote up'

        expect(page).to_not have_link "Vote up"
        expect(page).to_not have_link "Vote down"
      end
    end

    scenario 'may delete own vote' do
      within '.answers' do
        click_on 'Vote up'
        click_on 'Delete'

        expect(page).to have_link "Vote up"
        expect(page).to have_link "Vote down"
        expect(page).to have_content '0'
      end
    end
  end
end
