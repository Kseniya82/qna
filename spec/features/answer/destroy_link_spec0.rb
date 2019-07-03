require 'rails_helper'

feature 'Only author may delete links from own answer', %q{
  In order delete not rigth links etc
  As an authenticated user - author answer
  I'd like to be able delete links from answer
} do

  given(:users) { create_list(:user, 2) }
  given!(:answer) { create(:answer, user: users.first) }
  given!(:link) { answer.links.create!(name: 'google', url: 'https://www.google.com') }

  scenario 'Not authenticated user tried delete link', js: true do
    visit question_path(answer.question)

    expect(page).to_not have_link "Delete link"
  end

  scenario 'Author delete link', js: true do
    sign_in(users.first)
    visit question_path(answer.question)
    within '.answers' do
      click_on 'Delete link'
      expect(page).to_not have_link 'google', href: link.url
    end
  end

  scenario 'Not author tried delete link' do
    sign_in(users.last)
    visit question_path(answer.question)

    expect(page).to_not have_link "Delete link"
  end
end
