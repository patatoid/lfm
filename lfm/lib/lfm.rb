require 'net/http'
require 'uri'
require "rubygems"
require 'bundler/setup'
require 'nokogiri'
require 'date'

#uri = URI('http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=cher&api_key=b25b959554ed76058ac220b7b2e0a026')
#puts uri.inspect #Net::HTTP.get(uri)

module LFM
  HOST = 'ws.audioscrobbler.com'
  APIKEY = '13c7a00396a4727c8f0840c9ba80c43d'

  class Connexion
    def initialize
    end
  end

  class Base
    def initialize(params = {})
      params.each do |k,v|
        send("#{k}=", v) 
      end
    end
  end

  class Exception < Exception
    attr_accessor :code
    def initialize(code = nil, msg = nil)
      @code = code
      super(msg)
    end
    def message
      "code: #{code} msg: #{super}" 
    end
  end

  class Api
    def self.get(method, params={})
      res = Net::HTTP.start LFM::HOST do |http|
        path = ([] << "/2.0/?method=#{method}" << params.collect{|k,v| "#{k}=#{v}"}.join("&") << "api_key=#{LFM::APIKEY}").join("&")
        puts URI.escape(path)
        req = Net::HTTP::Get.new URI.escape(path)
        response = http.request req
      end

      #raise "HTTP error : #{res.code}"	unless res.code =~ /2\d\d/ 

      nok_res = Nokogiri::XML(res.body)
      if nok_res.at_css("lfm")['status'] = "failed"
        raise LFM::Exception.new(nok_res.at_css("error")['code'], nok_res.at_css("lfm error").content)
      end
      return res.body
    end

    def self.get_nok(method, params={})
     
      res = Net::HTTP.start LFM::HOST do |http|
        path = ([] << "/2.0/?method=#{method}" << params.collect{|k,v| "#{k}=#{v}"}.join("&") << "api_key=#{LFM::APIKEY}").join("&")
        puts URI.escape(path)
        req = Net::HTTP::Get.new URI.escape(path)
        response = http.request req
      end

      #raise "HTTP error : #{res.code}"	unless res.code =~ /2\d\d/ 

      nok_res = Nokogiri::XML(res.body)
      if nok_res.at_css("lfm")['status'] == "failed"
        raise LFM::Exception.new(nok_res.at_css("error")['code'], nok_res.at_css("lfm error").content)
      end
      return nok_res.remove_namespaces!
    end
  end

  class User < LFM::Base
    attr_accessor :name, :realname, :url
  end

  class Venue < LFM::Base
    attr_accessor :id, :name, :location, :url
  end

  class Event < LFM::Base
    attr_accessor :id, :title, :artists, :venue, :start_date, :start_time, :description, :attendance, :reviews, :tag, :url, :website, :tickets, :shouts

    def attend #need auth
    end

    #Get a list of attendees for an event. 
    def get_attendees(limit = 50)
      nok_result = LFM::Api.get_nok("event.getAttendees", {:event => id, :limit => limit})
      return nok_result.xpath("//user").inject({}) do |res, nok_user| 
        res.merge(LFM::User.new(:name => nok_suer.at_css("name").content,
                                :realname => nok_user.at_css("realname").content,
                                :url => nok_user.at_css("url").content))
      end	
    end

    #Get the metadata for an event on Last.fm. Includes attendance and lineup information. 
    def get_info
      nok_result = LFM::Api.get_nok("event.getInfo", {:event => id})
      self.title = nok_result.at_css("title").content
      self.artists = nok_result.xpath("//artists").inject({}) do |res, nok_artist| 
        res.merge({nok_artist.at_css("headliner").content => nok_artist.at_css("artist").content}) 
      end
      self.venue = LFM::Venue.new(:id => nok_result.at_css("venue id").content,
                                  :name => nok_result.at_css("venue name").content,
                                  :location => { :city => nok_result.at_css("venue location city").content,
                                    :country => nok_result.at_css("venue location country").content,
                                    :street => nok_result.at_css("venue location street").content,
                                    :postalcode => nok_result.at_css("venue location postalcode").content,
                                    :geo_point => { :geo_lat => nok_result.at_css("venue location point lat").content.to_f, 
                                      :geo_long => nok_result.at_css("venue location point long").content.to_f }
      },
                                  :url => nok_result.at_css("venue url").content
                                 )
                                 self.start_date = DateTime.parse(nok_result.at_css("startDate").content)
                                 self.description = nok_result.at_css("description").content
                                 self.attendance = nok_result.at_css("attendance").content.to_i
                                 self.reviews = nok_result.at_css("reviews").content.to_i
                                 self.tag = nok_result.at_css("tag").content
                                 self.website = nok_result.at_css("website").content
                                 self.tickets = nok_result.xpath("//ticket").inject({}) { |res, nok_ticket| res.merge(nok_ticket['supplier'].to_s => nok_ticket.content) }

    end

		#Get shouts for this event. Also available as an rss feed.
    def get_shouts
      nok_result = LFM::Api.get_nok("event.getShouts", {:event => self.id})
      
      self.shouts = nok_result.xpath("//shout").inject([]) do |res, nok_shout|
        res.push({ :body => nok_shout.at_css("body").content, 
                    :author => nok_shout.at_css("author").content, 
                    :date => DateTime.parse(nok_shout.at_css("date").content) })
      end
    end
  end

	def share #need auth
	end

	def shout #need auth
	end

  class Artist < LFM::Base
    attr_accessor :name, :mbid, :listenings, :url

		def add_tags #need auth
		end

    #Use the last.fm corrections data to check whether the supplied artist has a correction to a canonical artist 
    def get_correction
      nok_artist = LFM::Api.get_nok("artist.getcorrection", {:artist => self.name})
      self.name = nok_artist.at_css("name").content
			self.mbid = nok_artist.at_css("mbid").content
			self.url = nok_artist.at_css("url").content
    end

    #Use the last.fm corrections data to check whether the supplied artist has a correction to a canonical artist 
    def self.get_correction(name)
      nok_result = LFM::Api.get_nok("artist.getcorrection", {:artist => name})
      reutrn LFM::Aritst.new(:name => nok_result.at_css("name").content, :mbid => nok_result.at_css("mbid"), :url => nok_result.at_css("url"))
		end

		#Get a list of upcoming events for this artist. Easily integratable into calendars, using the ical standard (see feeds section below).
		def get_events
			nok_result = LFM::Api.get_nok("artist.getEvents", {:artist => self.name, :mbid => self.mbid})
		end

		#Get all the artists similar to this artist
    def get_similar
      i=0
      begin
        nok_artists = LFM::Api.get_nok("artist.getsimilar", {:artist => self.name})
      rescue
        i+=1
        retry if i < 5
      end
      similar_artists = {}
      nok_artists.xpath("//artist").each do |nok_artist|
        similar_artists.merge! nok_artist.at("match").content.to_f => Artist.new(:name => nok_artist.at("name").content, :mbid => nok_artist.at("mbid").content)
      end
      return similar_artists
    end

    def self.search(artist_name)
      nok_artists = LFM::Api.get_nok("artist.search", {:artist => artist_name})
      Artist.new(:name => nok_artists.at("name").content, :mbid => nok_artists.at("mbid").content)
    end

    def listenings
      i=0
      begin
        nok_tracks = LFM::Api.get_nok("artist.getTopTracks", {:artist => self.name, :limit => 100})
      rescue
        i+=1
        retry if i < 5
      end
      return nok_tracks.xpath("//playcount").inject(0) {|r, pc| r + pc.content.to_i }
    end
  end
end
