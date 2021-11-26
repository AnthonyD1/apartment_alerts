require "rails_helper"

RSpec.feature "User interacts with sidebar" do
  scenario "as a valid user", js: true do
    user = create(:user)
    sign_in(user)

    visit root_path
    click_on "canvas-open"

    expect(page).to have_content("Settings")
    expect(page).to have_content("Favorites")

    click_on "canvas-close"

    expect(page).to_not have_content("Settings")
    expect(page).to_not have_content("Favorites")
  end

  scenario "as guest", js: true do
    visit new_user_session_path

    click_on "Guest Login"
    click_on "canvas-open"

    expect(page).to have_content("Favorites")
    expect(page).to_not have_content("Settings")
  end
end
