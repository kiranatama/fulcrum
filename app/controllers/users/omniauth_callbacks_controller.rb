class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google
    omniauth = request.env["omniauth.auth"]
    @user = User.find_for_open_id(omniauth, current_user)

    if @user.try("persisted?")
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    elsif @user.blank?
      flash[:error] = I18n.t("devise.omniauth_callbacks.failure", :kind => "Google", :reason => "using non-allowable domain")
      redirect_to new_user_session_url
    else
      session["devise.google_data"] = omniauth
      redirect_to new_user_session_url
    end
  end
end
