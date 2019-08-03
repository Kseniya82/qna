class OauthConfirmationsController < Devise::ConfirmationsController
  def new;  end

  def create
    @email = oauth_confirmation_params[:email]
    password = Devise.friendly_token[0, 20]
    @user = User.new(email: @email, password: password, password_confirmation: password)

    if @user.valid?
      @user.save!
      auth
      @user.send_confirmation_instructions
    else
      flash.now[:alert] = 'please, enter valid email'
      render :new
    end
  end

  private

  def after_confirmation_path_for(resource_name, user)
    @user.create_authorization(auth)
    signed_in_root_path(@user)
  end

  def oauth_confirmation_params
    params.require(:user).permit(:email)
  end

  def resource
    @resource ||= User.new
  end

  def auth
    @auth ||= {
      provider: session['device.oauth_provider'],
      uid: session['device.oauth_uid']
    }
  end
end
