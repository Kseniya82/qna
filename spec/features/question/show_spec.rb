feature 'User can show list of question', %q{
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

feature 'User can create new answer on page question', %q{
  In order to create new answer
  As an any user
  I'd like to be able to write the answer on page question
} do
  given(:question) { create(:question) }
  scenario 'User write answer ' do
    visit question_path(question)
    fill_in 'answer_body', with: 'Answer body'
    click_on 'Add answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Answer body'
  end
  scenario 'User write answer with errors' do
    visit question_path(question)
    click_on 'Add answer'

    expect(page).to have_content "Body can't be blank"
  end
end
