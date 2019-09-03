require 'sphinx_helper'

feature 'user can search global or in areas', %q{
  Guest can do search and view results.
  Search available global or separately in
  Questions, Answers, Comments, Users
} do

  given!(:questions) { create_list :question, 5 }
  given!(:question) { questions.first }

  describe 'Searching for the', js: true, sphinx: true do
    before { visit root_path }

    scenario 'question' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: question.title
        click_on 'Search'

        expect(page).to have_content question.title

        questions.each do |q|
          expect(page).to_not have_content q.title
        end
      end
    end
  end
end
