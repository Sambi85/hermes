# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  #WIP - Used for customizing the password reset process, it's an override of the default Devise behavior.
  # ...customize the password reset email, link, or token behavior.
  # ...change how the reset form looks.
  # ...add special logic before or after the password reset (e.g., redirecting to a custom page after resetting the password).
end
