require 'rails_helper'

feature 'User creates an Alert' do
  before do
    user = create(:user)
    sign_in(user)
    stub_craigslist_call
  end

  scenario 'with valid input', js: true do
    visit root_path

    click_link 'New alert'
    fill_in 'Name', with: '1bd Under $800'
    select 'des moines', from: 'alert_city', visible: :all
    fill_in 'alert[search_params][max_price]', with: 800
    click_button 'Create'

    expect(page).to have_content('Alert created successfully.')
  end

  scenario 'with invalid input', js: true do
    visit root_path

    click_link 'New alert'
    click_button 'Create'

    expect(page).to have_content('errors prohibited this article from being saved:')
  end

  def stub_craigslist_call
    allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([])
  end
end
