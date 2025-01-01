class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Allow additional fields to be used during sign-up
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :other_field])
  end
end
