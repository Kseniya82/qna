require 'rails_helper'

feature 'Only author may delete own question', %q{
  In order delete question with error etc
  As an authenticated user - author question
  I'd like to be able delete question
} do

  given(:users) { create_list(:user, 2) }
  background { sign_in(users.first) }
  given!(:question) { create(:question, user_id: users.first.id) }

  scenario 'Author delete question' do

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to_not have_content question.title
  end

  scenario 'Not author tried delete question' do
    visit root_path
    click_on 'Log out'
    sign_in(users.last)

    visit question_path(question)
    expect(page).to_not have_link "Delete question"
  end

  scenario 'Not authenticated user tried delete question' do
    visit root_path
    click_on 'Log out'

    visit question_path(question)
    expect(page).to_not have_link "Delete question"
  end
end
