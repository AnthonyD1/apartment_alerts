require 'rails_helper'

RSpec.feature 'Visitor Signs up' do
  scenario 'with valid email and password' do
    sign_up_with(username: 'Foobar', email: 'foo@bar.com', password: 'password')

    expect(page).to_not have_content('Log in')
  end

  scenario 'with invalid credentials' do
    sign_up_with(username: '', email: '', password: '')

    expect(page).to have_content('errors')
    expect(page).to have_content('Log in')
  end

  def sign_up_with(username:, email:, password:)
    visit new_user_registration_path

    fill_in 'user_username', with: username
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password

    click_button 'Sign up'
  end
end
