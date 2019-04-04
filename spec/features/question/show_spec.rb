feature 'User can create question', %q{
  In order to find similar problem
  As an any user
  I'd like to be able to look the list of questions
} do
  given(:questions) { create_list(:question, 3) }

  scenario 'User show list of questions' do

    questions.each do |q|
      visit new_question_path
      fill_in 'Title', with: q.title
      fill_in 'Body', with: q.body
      click_on 'Ask'
    end

    visit questions_path
    questions.all? do |q|
      expect(page).to have_content q.title
    end
  end
end
