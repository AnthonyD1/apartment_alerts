require "rails_helper"

Rails.application.load_tasks

RSpec.describe "delete guests task" do
  it "destroys guest users and associated alerts" do
    create(:user)
    user = create(:user, :guest)
    create(:alert, user: user)

    Rake::Task["users:delete_guests"].invoke

    expect(Alert.count).to be_zero
    expect(User.count).to eq(1)
  end
end
