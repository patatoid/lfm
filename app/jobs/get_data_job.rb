class GetDataJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    unless Artist.all.any?
      a = LFM::Artist.get_correction("Portishead")
      a = Artist.create(:name => a.name, :mbid => a.mbid)
    end
    Artist.where(visited: nil).each do |a|
      a.graph(10, 100)
    end
  end
end
