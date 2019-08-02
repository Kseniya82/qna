module OmniauthMacros
  def mock_auth_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123',
      info: { email: 'github@mail.net'}
    )
  end
  def mock_auth_mailru
    OmniAuth.config.mock_auth[:mail_ru] = OmniAuth::AuthHash.new(
      provider: 'mailru',
      uid: '123',
      info: { email: '123@mail.ru'}
    )
  end
end
