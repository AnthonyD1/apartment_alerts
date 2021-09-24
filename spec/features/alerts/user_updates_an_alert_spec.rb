require 'rails_helper'

feature 'User updates an Alert' do
  before do
    allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([])
    user = create(:user)
    sign_in(user)
    @alert = create(:alert, user: user, name: '1bd under $800')
  end

  scenario 'with valid input', js: true do
    visit root_path

    click_link "Edit alert #{@alert.id}"
    fill_in 'Name', with: '1bd under $900'
    select 'boston', from: 'alert_city', visible: :all
    click_button 'Update'

    expect(page).to have_content('Alert updated successfully.')
    expect(page).to have_content('1bd under $900')
  end

  scenario 'with invalid input' do
    visit root_path

    click_link "Edit alert #{@alert.id}"
    fill_in 'Name', with: ''
    click_button 'Update'

    expect(page).to have_content('error prohibited this article from being saved:')
  end
end
