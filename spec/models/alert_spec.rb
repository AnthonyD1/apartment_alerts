require 'rails_helper'

RSpec.describe Alert do
  describe '#pull_posts' do
    before do
      @alert = Alert.new(city: 'des moines',
                         search_params: { hasPic: '1', max_bedrooms: '1' },
                         average_post_time: 600)
    end

    context '1 or less new posts' do
      it 'does not update the average when no new posts' do
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([])

       @alert.pull_posts

        expect(@alert.average_post_time).to eq(600)
      end

      it 'does not update the average when only one new post' do
        post = CraigslistPost.new
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([post])

        @alert.pull_posts

        expect(@alert.average_post_time).to eq(600)
      end

      it 'does not add any posts to #craigslist_posts' do
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([])

        @alert.pull_posts

        expect(@alert.craigslist_posts.count).to eq(0)
      end
    end

    context 'more than 1 new posts' do
      before do
        user = User.create(email: 'a@foo.com', username: 'foo', password: 'password')
        posts = [ CraigslistPost.new(post_id: 123, date: DateTime.current),
                   CraigslistPost.new(post_id: 1234, date: DateTime.current + 300.seconds)]
        @alert = Alert.create(city: 'des moines',
                             search_params: { hasPic: '1', max_bedrooms: '1' },
                             average_post_time: 600,
                             average_post_time_count: 1,
                             user_id: 1)

        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return(posts)
      end

      it 'updates the average post time when more than 1 new post' do
        @alert.pull_posts

        expect(@alert.average_post_time).to eq(450)
        expect(@alert.average_post_time_count).to eq(2)
      end

      it 'updates #craigslist_posts with new posts' do
        @alert.pull_posts

        expect(@alert.craigslist_posts.count).to eq(2)
      end
    end
  end
end
