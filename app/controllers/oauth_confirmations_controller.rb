class OauthConfirmationsController < Devise::ConfirmationsController
  def show
    byebug
    # super { |user| byebug; sign_in user }
    byebug
    user2  =  User.confirm_by_token(params[:confirmation_token])

  end

  def create
    @email = oauth_confirmation_params[:email]
    password = Devise.friendly_token[0, 20]
    @user = User.new(email: @email, password: password, password_confirmation: password)

    if @user.valid?
      @user.save!
      @user.create_authorization(auth)
      @user.send_confirmation_instructions
      self.resource = @user
    else
      flash.now[:alert] = 'please, enter valid email'
      render :new
    end
  end

  private

  # def after_confirmation_path_for(resource_name, user)
  #   user  =  User.confirm_by_token(params[:confirmation_token])
  #   sign_in resource, event: :authentication
  #   root_path
  # end
  def oauth_confirmation_params
    params.require(:user).permit(:email)
  end

  # def resource
  #   @resource ||= User.new
  # end

  def auth
    @auth ||= {
      provider: session['devise.oauth_provider'],
      uid: session['devise.oauth_uid']
    }
  end
end