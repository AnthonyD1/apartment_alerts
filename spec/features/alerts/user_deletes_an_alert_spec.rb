require 'rails_helper'

feature 'User deletes an Alert', js: true do
  scenario do
    user = create(:user)
    sign_in(user)
    @alert = create(:alert, user: user, name: '1 bd under $800')

    visit dashboard_path

    click_link "Delete alert #{@alert.id}"
    page.accept_prompt

    expect(page).to_not have_content('1 bd under $800')
  end
end
