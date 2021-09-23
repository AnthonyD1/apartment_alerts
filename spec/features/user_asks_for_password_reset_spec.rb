require 'rails_helper'

feature 'User asks for password reset' do
    let(:expected_content) { 'You will receive an email with instructions on how to reset your password in a few minutes.' }

  scenario 'with valid email' do
    user = create(:user)

    reset_password(user)

    expect(page).to have_content(expected_content)
  end

  scenario 'with invalid email' do
    user = build_stubbed(:user, email: '')

    reset_password(user)

    expect(page).to_not have_content(expected_content)
  end

  def reset_password(user)
    visit new_user_session_path
    click_on 'Forgot your password?'
    fill_in 'user_email', with: user.email
    click_button 'Send me reset password instructions'
  end
end
