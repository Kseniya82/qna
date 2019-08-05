require 'rails_helper'

feature 'User can sign in via OAuth providers:', %q{
  In order to log in without signin up
  As an unauthenticated user
  I'd like to be able to use oauth sign in
 } do

  background { visit new_user_session_path }

  context 'GitHub account' do
    scenario 'with correct credentials' do
      mock_auth_github
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Authentication failed, please try again'
    end
  end

  context 'MailRu account' do
    scenario 'with correct credentials' do
      mock_auth_mailru
      click_on 'Sign in with MailRu'

      expect(page).to have_content 'Successfully authenticated from Mailru account.'
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:mail_ru] = :invalid_credentials
      click_on 'Sign in with MailRu'

      expect(page).to have_content 'Authentication failed, please try again'
    end
  end

  context 'Vkontakte account' do
    scenario 'with correct credentials' do
      mock_auth_vkontakte
      click_on 'Sign in with Vkontakte'
      fill_in 'user_email', with: '1234@user.com'
      click_on 'Resend confirmation instructions'

      expect(page).to have_content "Email confirmation instructions send to 1234@user.com"

      open_email('1234@user.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed'
    #  click_on 'Log out'
    #  visit new_user_session_path
    #  expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Authentication failed, please try again'
    end
  end

end
