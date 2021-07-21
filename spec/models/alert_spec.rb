require 'rails_helper'

RSpec.describe Alert do
  describe '#pull_posts' do
    before do
      ActiveJob::Base.queue_adapter = :test
      @user = User.create(email: 'a@foo.com', username: 'foo', password: 'password')
      @alert = Alert.create(user: @user,
                            city: 'des moines',
                            search_params: { hasPic: '1', max_bedrooms: '1' },
                            average_post_time: 600)
      allow(@alert).to receive(:touch)
    end

    context 'no new posts' do
      before do
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([])
        @alert.pull_posts
      end

      it 'does not update the average' do
        expect(@alert.average_post_time).to eq(600)
      end

      it 'does not add any posts to #craigslist_posts' do
        expect(@alert.craigslist_posts.count).to eq(0)
      end

      it 'does not send new posts email' do
        enqueued_jobs = ActiveJob::Base.queue_adapter.enqueued_jobs

        expect(enqueued_jobs.count).to eq(0)
      end
    end

    context '1 new post' do
      it 'does not update the average' do
        post = CraigslistPost.new(id: 1)
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([post])

        @alert.pull_posts

        expect(@alert.average_post_time).to eq(600)
      end

      it 'adds new posts to #craigslist_posts' do
        posts = [ CraigslistPost.new(post_id: 123, date: DateTime.current, post: {})]
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return(posts)

        @alert.pull_posts

        expect(@alert.craigslist_posts.count).to eq(1)
      end

      it 'enqueues new posts email' do
        post = CraigslistPost.new(id: 1)
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([post])

        @alert.pull_posts

        enqueued_jobs = ActiveJob::Base.queue_adapter.enqueued_jobs

        expect(enqueued_jobs.count).to eq(1)
      end
    end

    context 'more than 1 new posts' do
      before do
        posts = [ CraigslistPost.new(post_id: 123, date: DateTime.current, post: {}),
                   CraigslistPost.new(post_id: 1234, date: DateTime.current + 300.seconds, post: {})]

        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return(posts)
      end

      it 'updates the average post time' do
        @alert.average_post_time = 600
        @alert.average_post_time_count = 1

        @alert.pull_posts

        expect(@alert.average_post_time).to eq(450)
        expect(@alert.average_post_time_count).to eq(2)
      end

      it 'updates #craigslist_posts with new posts' do
        @alert.pull_posts

        expect(@alert.craigslist_posts.count).to eq(2)
      end

      it 'enqueues new posts email' do
        post = CraigslistPost.new(id: 1)
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([post])

        @alert.pull_posts

        enqueued_jobs = ActiveJob::Base.queue_adapter.enqueued_jobs

        expect(enqueued_jobs.count).to eq(1)
      end
    end

    context '#last_pulled_at' do
      it 'is updated' do
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([])

        @alert.pull_posts

        expect(@alert).to have_received(:touch).with(:last_pulled_at)
      end
    end
  end

  describe '#filtered_search_params' do
    it 'returns non empty params' do
      alert = Alert.new(search_params: { hasPic: '0', postal: '', postedToday: '1'})

      expect(alert.filtered_search_params).to eq({postedToday: '1'})
    end
  end

  describe '#repull_delay' do
    context 'average_pull_time is zero' do
      it 'returns the default delay' do
        alert = Alert.new
        default_delay = 1.hour.seconds

        expect(alert.repull_delay).to eq(default_delay)
      end
    end

    context 'average_pull_time is not zero' do
      it 'returns the average_post_time' do
        alert = Alert.new(average_post_time: 600)

        expect(alert.repull_delay).to eq(600)
      end
    end
  end
end
