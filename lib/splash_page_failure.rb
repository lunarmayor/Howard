class SplashPageFailure < Devise::FailureApp
  def redirect_url
    if request.flash['alert'].present? && request.flash['alert'] != "You need to sign in or sign up before continuing."
      new_user_session_url
    else
      splash_url
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end