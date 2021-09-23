require 'rails_helper'

RSpec.feature 'User signs in' do
  scenario 'as guest' do
    visit new_user_session_path

    click_on 'Guest Login'

    expect(page).to_not have_content('Log in')
  end

  scenario 'with valid credentials' do
    user = create(:user, email: 'foo@example.com', password: 'password')

    login(user)

    expect(page).to_not have_content('Log in')
  end

  scenario 'with invalid credentials' do
    user = build_stubbed(:user, email: '', password: '')

    login(user)

    expect(page).to have_content('Log in')
  end

  def login(user)
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button 'Log in'
  end
end
