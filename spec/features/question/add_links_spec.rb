require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Kseniya82/a84079fda58dc44e8a8165063e3715a3' }
  given(:google_url) { 'https://google.com' }
  given(:invalid_url) {'33.ru'}

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    fill_in  'Link name', with: 'google', currently_with: ''
    fill_in 'Url', with: google_url, currently_with: ''

    click_on 'Ask'

    expect(page).to have_content 'test.txt'
    expect(page).to have_link 'google', href: google_url
  end

  scenario 'User adds links with invalid url', js: true do
    sign_in(user)
    visit new_question_path

    click_on 'add link'

    fill_in 'Link name', with: 'bad url'
    fill_in 'Url', with: invalid_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
  end
end
