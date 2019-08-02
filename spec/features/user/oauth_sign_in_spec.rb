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

      expect(page).to have_content 'Could not authenticate you from GitHub because'
    end
  end

  context 'MailRu account' do
    scenario 'with correct credentials' do
      mock_auth_mailru
      click_on 'Sign in with MailRu'

      expect(page).to have_content 'Successfully authenticated from MailRu account.'
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:mail_ru] = :invalid_credentials
      click_on 'Sign in with MailRu'

      expect(page).to have_content 'Could not authenticate you from MailRu because'
    end
  end

end
