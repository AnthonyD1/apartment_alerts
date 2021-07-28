RSpec.configure do |config|
  config.include(ActiveJob::TestHelper)
end

class ActiveJob::QueueAdapters::DelayedJobAdapter
  def enqueued_jobs(options = {})
    conditions = { failed_at: nil }
    conditions[:queue] = options[:queue] if options[:queue].present?

    Delayed::Job.where(conditions)
  end

  def performed_jobs(options = {})
    conditions = {}
    conditions[:queue] = options[:queue] if options[:queue].present?

    Delayed::Job.where(conditions)
      .where.not(failed_at:nil)
  end
end
