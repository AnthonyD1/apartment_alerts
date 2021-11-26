namespace :users do
  desc "destroys all guest user accounts"
  task delete_guests: :environment do
    User.where(username: 'guest').destroy_all
  end
end
