Snippet.add(:work_tracker) do
  on

  # require File.expand_path("~/wtracker/work_tracker.rb")


  def ww
    WorkTracker.ww
  end

  def wt
    WorkTracker
  end

  delegate_to :WorkTracker
end
