require 'rails_helper'

feature 'Only author may delete own answer', %q{
  In order delete answer with error etc
  As an authenticated user - author answer
  I'd like to be able delete answer
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: users.first, question: question) }

  scenario 'Author delete answer' do
    sign_in(users.first)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Not author tried delete answer' do
    sign_in(users.last)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Not authenticated user tried delete answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
