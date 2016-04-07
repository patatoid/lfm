class GetDataJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    begin
    Artist
      .where('result_artist.listenings IS NOT NULL AND result_artist.visited IS NULL')
      .order('result_artist.listenings DESC')
      .first.graph(2, 100)
    rescue
    end
    self.class.perform_later
  end
end
