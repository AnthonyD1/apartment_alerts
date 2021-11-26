require "rails_helper"

Rails.application.load_tasks

RSpec.describe "cleanup_soft_deletes" do
  it "permanently deletes soft deleted posts" do
    create(:craigslist_post, :soft_deleted)
    create(:craigslist_post)

    Rake::Task["posts:cleanup_soft_deletes"].invoke

    expect(CraigslistPost.count).to eq(1)
  end
end
