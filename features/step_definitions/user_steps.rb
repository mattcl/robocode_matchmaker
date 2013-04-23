Given(/^I am not authenticated$/) do
  visit destroy_user_session_path
end

Given(/^I am authenticated$/) do
  username = 'derp'
  email = 'derp@testing.com'
  password = 'test1234'
  User.new(:username => username, :email => email, :password => password, :password_confirmation => password).save!
  visit new_user_session_path
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Sign in"
end
