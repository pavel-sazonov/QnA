class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_with('github')
  end

  def vkontakte
    sign_in_with('vk')
  end

  private

  def sign_in_with(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
  end
end
