require 'rails_helper'

feature 'User marks alert as seen' do
  scenario 'when not seen' do
    user = create(:user)
    sign_in(user)
    alert = create(:alert, user: user, seen: false, name: '1bd under $800')

    visit root_path
    page.has_css?('.table-primary', count: 1)

    click_link '1bd under $800'
    click_link 'Apartment Alerts', visible: :all

    page.has_css?('.table-primary', count: 0)
  end
end
