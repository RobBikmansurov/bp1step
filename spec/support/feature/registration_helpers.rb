module Features
  module RegistrationHelpers
    def sign_up_with(email, password)
      visit "/users/sign_up"
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password
      click_button "Sign up"
    end
  end
end

