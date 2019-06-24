require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Kseniya82/a84079fda58dc44e8a8165063e3715a3' }
  given(:google_url) { 'https://google.com' }

  scenario 'User adds links when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    click_on 'add link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    fill_in  'Link name', with: 'google', currently_with: ''
    fill_in 'Url', with: google_url, currently_with: ''

    click_on 'Add answer'
    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'google', href: google_url
    end
  end
end
