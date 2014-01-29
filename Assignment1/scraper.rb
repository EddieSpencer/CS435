require 'rubygems'
require 'nokogiri'
require 'open-uri'

US_CHARTS = "http://charts.spotify.com/embed/charts/most_streamed/us/latest"
GB_CHARTS = "http://charts.spotify.com/embed/charts/most_streamed/gb/latest"

class Track
    attr_accessor :rank, :name, :artist, :stats
    
    def initialize rank, name, artist, stats
        @rank = rank
        @name = name
        @artist = artist
        @stats = stats
        
    end
    
    def to_s
<<-EOF
    Name: #{name}
    Rank: #{rank}
    Stats: #{stats}
    
EOF
        
    
    end
    
    
end

def getTracks page
    
    url = Nokogiri::HTML(open(page))
    
    url.css('div.track-info').map do |elem|
    
        rank, name = elem.css('p.track-rank-name').text.split('. ', 2)
    
        artist = elem.css('span.track-artist').text
    
        stats = elem.css('span.track-stats').text.split.first.delete(',').to_i
    
        Track.new(rank, name, artist, stats)
    end
end

top50US = getTracks US_CHARTS
top50GB = getTracks GB_CHARTS


top50US = top50US.group_by {|obj| obj.artist}
top50GB = top50GB.group_by {|obj| obj.artist}

print "Enter the country whose top artists you wish to view: (US or GB) "

choice = gets
choice.chomp!

if choice == "US"
    top50US.sort.each do |artist|
        puts artist
        end
elsif choice == "GB"
    top50GB.sort.each do |artist|
        puts artist
        end
end












