require 'rails_helper'

RSpec.describe PullPostsJob do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#perform' do
    it 'calls Alert#refresh' do
      alert = spy('alert')

      described_class.perform_now(alert)

      expect(alert).to have_received(:refresh)
    end
  end
end
