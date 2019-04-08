require 'rails_helper'

feature 'User can register', %q{
  In order to ask questions
  As an unregistered user
  I'd like to be able to register
} do

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to register' do
    fill_in 'Email', with: 'good@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to register with errors' do
    fill_in 'Email', with: 'bad@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Registered user tries to register' do
    fill_in 'Email', with: 'good@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    click_on 'Log out'
    visit new_user_registration_path
    fill_in 'Email', with: 'good@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
