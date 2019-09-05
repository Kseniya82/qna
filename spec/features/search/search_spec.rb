require 'sphinx_helper'

feature 'user can search global or in areas', %q{
  Guest can do search and view results.
  Search available global or separately in
  Questions, Answers, Comments, Users
} do

  given!(:questions) { create_list :question, 3 }
  given!(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:users) { create_list(:user, 3)}
  given!(:answer) { create(:answer) }
  given!(:answers) { create_list(:answer, 3)}
  given!(:comment) { create(:comment, commentable: question) }
  given(:comments) { create_list(:comment, 3) }

  describe 'Searching for the', js: true, sphinx: true do
    before { visit root_path }

    scenario 'question' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: question.title
        select 'question', from: 'scope'
        click_on 'Search'

        expect(page).to have_content question.title

        questions.each do |q|
          expect(page).to_not have_content q.title
        end
      end
    end

    scenario 'answer' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: answer.body
        select 'answer', from: 'scope'
        click_on 'Search'

        expect(page).to have_content answer.body

        answers.each do |a|
          expect(page).to_not have_content a.body
        end
      end
    end

    scenario 'cpomment' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: comment.body
        select 'comment', from: 'scope'
        click_on 'Search'

        expect(page).to have_content comment.body

        comments.each do |c|
          expect(page).to_not have_content c.body
        end
      end
    end

    scenario 'user' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: user.email
        select 'user', from: 'scope'
        click_on 'Search'

        expect(page).to have_content user.email

        userrs.each do |u|
          expect(page).to_not have_content u.body
        end
      end
    end

    scenario 'thinking_sphinx' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: user.email
        select 'thinking_sphinx', from: 'scope'
        click_on 'Search'

        expect(page).to have_content user.email

        userrs.each do |u|
          expect(page).to_not have_content u.body
        end

        questions.each do |q|
          expect(page).to_not have_content q.title
        end
      end
    end
  end
end
