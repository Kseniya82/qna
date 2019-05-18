require 'rails_helper'

feature 'Author question can mark best one answer for own question', %q{
  In order to choose the best answer
  As an author of question
  I'd like ot be able to mark answer as best
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:own_question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: own_question) }

  scenario 'Unauthenticated can not mark answer as best' do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end

  context 'Authentication user', js: true do
    background do
      sign_in(user)
    end

    scenario 'Author of question can mark answer as best' do
      visit question_path(own_question)

      first('.mark-as-best').click
      first('.mark-as-best').click

      expect(page).to have_css('.best', count: 1)
    end

    scenario 'Author of question can mark other answer as best if question alredy have best answer' do
      answers.first.update(best: true)
      visit question_path(own_question)
      first('.mark-as-best').click

      expect(page).to have_css('.best', count: 1)
    end

    scenario 'Not author can not mark answer as best' do
      visit question_path(question)

      expect(page).to_not have_link 'Mark as best'
    end
  end
end
