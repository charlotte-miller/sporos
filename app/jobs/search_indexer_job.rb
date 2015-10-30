class SearchIndexerJob < ActiveJob::Base
  queue_as :search

  def perform(*args)
    # Do something later
  end
end
