require 'rails_helper'

feature 'User manages craigslist posts', js: true do
  before do
    user = create(:user)
    sign_in(user)
    @alert = create(:alert, name: '1 bd under $800', user: user)
  end

  scenario 'navigates to alerts show' do
    visit dashboard_path
    click_link @alert.name

    expect(page).to have_content('Next refresh in about')
  end

  scenario 'marks a post as seen' do
    post = create(:craigslist_post, alert: @alert)
    visit alert_path(@alert.id)

    page.has_css?('.table-primary', count: 1)
    new_window = window_opened_by { click_link post.title }
    within_window new_window do
      expect(page).to_not have_content('Apartment Alerts')
    end
    page.has_css?('.table-primary', count: 0)
  end

  scenario 'favorites a post' do
    post1, post2 = create_pair(:craigslist_post, alert: @alert)

    visit alert_path(@alert.id)
    within(:xpath, "//table/tbody/tr[1]") do
      expect(page).to have_content(post2.title)
    end

    click_link "Favorite post #{post1.id}"
    refresh

    within(:xpath, "//table/tbody/tr[1]") do
      expect(page).to have_content(post1.title)
    end
  end

  scenario 'deletes a single post' do
    post1, post2 = create_pair(:craigslist_post, alert: @alert)

    visit alert_path(@alert.id)

    click_link "Delete post #{post1.id}"

    expect(page).to_not have_content(post1.title)
  end

  scenario 'deletes multiple posts' do
    post1, post2 = create_pair(:craigslist_post, alert: @alert)
    create(:craigslist_post, alert: @alert)

    visit alert_path(@alert.id)

    check "delete-checkbox-#{post1.id}"
    check "delete-checkbox-#{post2.id}"
    click_button 'Delete selected'

    expect(page).to have_content('Posts deleted.')
    expect(page).to_not have_content(post1.title)
    expect(page).to_not have_content(post2.title)
  end
end
