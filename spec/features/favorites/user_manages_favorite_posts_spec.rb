require 'rails_helper'

feature 'User manages favorite posts' do
  scenario 'navigates to the favorites page' do
    user = create(:user)
    sign_in(user)

    alert = create(:alert, user_id: user.id)
    create(:craigslist_post, :favorite, title: 'Foobar', alert: alert)

    visit dashboard_path
    click_link 'Favorites'

    expect(page).to have_content('Foobar')
  end
end
