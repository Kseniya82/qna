require 'rails_helper'

feature 'User can sign out', %q{
  In order to close session
  As an authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
