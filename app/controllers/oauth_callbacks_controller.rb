class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth
  def github; end

  def mail_ru; end

  def vkontakte; end

  private

  def oauth
    auth = request.env['omniauth.auth']
    unless auth
      redirect_to new_user_session_path, alert: 'Authentication failed, please try again.'
      return
    end

    @user = User.find_for_oauth(auth)

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.to_s.capitalize) if is_navigational_format?
    else
      session['devise.oauth_provider'] = auth.provider
      session['devise.oauth_uid'] = auth.uid
      redirect_to new_user_confirmation_path
    end
  end

end
