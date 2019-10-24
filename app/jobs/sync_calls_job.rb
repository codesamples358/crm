class SyncCallsJob < ApplicationJob
  queue_as :default
  FREQUENCY = 1.hour

  def perform(*args)
    Call.import_from( FREQUENCY.ago )
    self.class.set(wait: FREQUENCY * 0.9).perform_later
  end
end
