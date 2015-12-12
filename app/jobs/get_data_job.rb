class GetDataJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    while true
      Artist
        .where('result_artist.listenings IS NOT NULL AND result_artist.visited IS NULL')
        .order('result_artist.listenings DESC')
        .limit(1)
        .each do |a|
        a.graph(5, 100)
      end
    end
  end
end
