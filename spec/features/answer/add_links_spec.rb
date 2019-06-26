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
  given(:invalid_url) { '33.ru' }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end
  scenario 'User adds links when add answer', js: true do

    fill_in 'Your answer', with: 'My answer'

    click_on 'add link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    fill_in  'Link name', with: 'google', currently_with: ''
    fill_in 'Url', with: google_url, currently_with: ''

    click_on 'Add answer'
    within '.answers' do
      expect(page).to have_content 'test.txt'
      expect(page).to have_link 'google', href: google_url
    end
  end

  scenario 'User adds links with invalid url', js: true do

    click_on 'add link'

    fill_in 'Link name', with: 'bad url'
    fill_in 'Url', with: invalid_url

    click_on 'Add answer'

    expect(page).to have_content 'Links url is not a valid URL'
  end

  scenario 'edits a answer with adds link', js: true do
    within '.answers' do
      first(:link, 'Edit').click
      first(:link, 'add link').click

      new_link_nested_form = all('.nested-fields').last
      within(new_link_nested_form) do
        fill_in 'Link name', with: 'google'
        fill_in 'Url', with: google_url
      end

      click_on 'Save'

      expect(page).to have_link 'google', href: google_url
    end
  end
end
