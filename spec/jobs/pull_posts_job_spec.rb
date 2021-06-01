require 'rails_helper'

RSpec.describe PullPostsJob do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#perform' do
    it 'calls Alert#pull_posts' do
      alert = spy('alert')

      described_class.perform_later(alert)

      expect(alert).to receive(:pull_posts)
    end

    it 'enqueues another PullPostsJob for the future' do
      alert = Alert.new(id: 1, average_post_time: 600)
      allow(Alert).to receive(:find).and_return(alert)
      allow(alert).to receive(:pull_posts)

      described_class.perform_now(alert)
      enqueued_job = ActiveJob::Base.queue_adapter.enqueued_jobs.first
      future = Time.at(enqueued_job[:at])

      expect(described_class).to have_been_enqueued.with(alert)
      expect(future).to be_within(600.seconds).of(Time.now)
    end
  end
end
