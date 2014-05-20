def signin(auth, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    auth.user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    within '.form' do
      fill_in "email",    with: auth.email
      fill_in "password", with: auth.password
      click_button "Sign In"
    end
  end
end