class GetDataJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Artist.where(visited: nil).limit(100).each do |a|
      a.graph(10, 100)
    end
  end
end
