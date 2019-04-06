require 'rails_helper'

feature 'Only author may delete own answer', %q{
  In order delete answer with error etc
  As an authenticated user - author answer
  I'd like to be able delete answer
} do

  given(:users) { create_list(:user, 2) }
  background { sign_in(users.first) }
  given!(:question) { create(:question, user_id: users.first.id) }
  given!(:answer) { create(:answer, user_id: users.first.id, question_id: question.id) }

  scenario 'Author delete answer' do

    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Not author tried delete answer' do
    visit root_path
    click_on 'Log out'
    sign_in(users.last)

    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content "Access denided"
  end
end
