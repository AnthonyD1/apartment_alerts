require 'rails_helper'

RSpec.describe Alert do
  before do
    ActiveJob::Base.queue_adapter = :delayed_job

    @user = build_stubbed(:user)
    @alert = create(:alert, :emails_enabled, average_post_time: 600)
  end

  describe '#enqueue_pull_posts_job' do
    context 'a job does not exist' do
      before do
        @alert.enqueue_pull_posts_job
      end

      it 'sets the job_id on the alert' do
        expect(@alert.job_id).to_not be_nil
      end

      it 'enqueues pull posts job' do
        expect(enqueued_jobs(queue: 'pull_posts').count).to eq(1)
      end
    end

    context 'a job already exists' do
      before do
        @old_job_id = @alert.job_id

        @alert.enqueue_pull_posts_job
      end

      it 'destroys old pull posts job' do
        expect{ Delayed::Job.find(@old_job_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'enqueues new pull posts job for the future' do
        new_job = Delayed::Job.find(@alert.job_id)
        future = Time.at(new_job.run_at)

        expect(future).to be_within(600.seconds).of(Time.now)
        expect(new_job).to_not be_nil
      end

      it 'updates the job_id on the alert' do
        expect(@alert.job_id).to_not eq(@old_job_id)
      end
    end
  end

  context 'validations' do
    context 'presence' do
      it 'includes expected fields' do
        alert = Alert.new
        validated_fields = %i(city name user search_params)

        alert.valid?

        expect(alert.errors.messages).to include(*validated_fields)
      end
    end
  end

  describe '#refresh' do
    context 'no new posts' do
      before do
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([])

        @alert.refresh
      end

      it 'does not update the average' do
        expect(@alert.average_post_time).to eq(600)
      end

      it 'does not add any posts to #craigslist_posts' do
        expect(@alert.craigslist_posts.count).to eq(0)
      end

      it 'does not send new posts email' do
        expect(enqueued_jobs(queue: 'mailers').count).to eq(0)
      end

      it 'does not enqueue a new pull posts job' do
        expect(enqueued_jobs(queue: 'pull_posts').count).to eq(0)
      end
    end

    context '1 new post' do
      before do
        posts = [ build(:craigslist_post, alert: @alert) ]
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return(posts)

        @alert.refresh
      end

      it 'does not update the average' do
        expect(@alert.average_post_time).to eq(600)
      end

      it 'adds new posts to #craigslist_posts' do
        expect(@alert.craigslist_posts.count).to eq(1)
      end

      it 'enqueues new posts email' do
        expect(enqueued_jobs(queue: 'mailers').count).to eq(1)
      end

      it 'enqueue a new pull posts job' do
        expect(enqueued_jobs(queue: 'pull_posts').count).to eq(1)
      end
    end

    context 'more than 1 new posts' do
      before do
        posts = [ build(:craigslist_post, alert: @alert),
                  build(:craigslist_post, alert: @alert, date: DateTime.current + 300.seconds)]

        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return(posts)
      end

      it 'updates the average post time' do
        @alert.average_post_time = 600
        @alert.average_post_time_count = 1

        @alert.refresh

        expect(@alert.average_post_time).to eq(450)
        expect(@alert.average_post_time_count).to eq(2)
      end

      it 'updates #craigslist_posts with new posts' do
        @alert.refresh

        expect(@alert.craigslist_posts.count).to eq(2)
      end

      it 'enqueues new posts email' do
        post = CraigslistPost.new(id: 1)
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([post])

        @alert.refresh

        expect(enqueued_jobs(queue: 'mailers').count).to eq(1)
      end
    end

    context 'emails not enabled' do
      it 'does not enqueue new posts email' do
        @alert.emails_enabled = false
        post = CraigslistPost.new(id: 1)
        allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([post])

        @alert.refresh

        expect(enqueued_jobs(queue: 'mailers').count).to eq(0)
      end
    end
  end

  describe '#pull_posts' do
    it 'calls CraigslistQuery' do
      expect(CraigslistQuery).to receive_message_chain(:new, :posts)

      @alert.pull_posts
    end

    it '#last_pulled_at is updated' do
      allow_any_instance_of(CraigslistQuery).to receive(:posts).and_return([])

      expect(@alert).to receive(:touch).with(:last_pulled_at)

      @alert.pull_posts
    end
  end

  describe '#filtered_search_params' do
    it 'returns non empty params' do
      @alert.search_params = { hasPic: '0', postal: '', postedToday: '1'}

      expect(@alert.filtered_search_params).to eq({postedToday: '1'})
    end
  end

  describe '#repull_delay' do
    context 'average_pull_time is zero' do
      it 'returns the default delay' do
        @alert.average_post_time = 0
        default_delay = 1.hour.seconds

        expect(@alert.repull_delay).to eq(default_delay)
      end
    end

    context 'average_pull_time is not zero' do
      it 'returns the average_post_time' do
        @alert.average_post_time =  600

        expect(@alert.repull_delay).to eq(600)
      end
    end
  end

  describe '#next_pull_time' do
    it 'returns the time of the next pull' do
      last_pulled_at = DateTime.parse('2021-01-01')
      @alert.assign_attributes(last_pulled_at: last_pulled_at, average_post_time: 600)

      expected_time = last_pulled_at + 10.minutes

      expect(@alert.next_pull_time).to eq(expected_time)
    end

    context 'when nil' do
      it 'returns the default repull delay' do
        @alert.assign_attributes(last_pulled_at: nil, average_post_time: 0)
        expected_time = 1.hour.seconds

        expect(@alert.next_pull_time).to be_within(expected_time).of(DateTime.current)
      end
    end
  end
end
