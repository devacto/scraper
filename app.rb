require 'HTTParty'
require 'Nokogiri'
require 'JSON'

page = HTTParty.get('http://viki.com')

parse_page = Nokogiri::HTML(page)

# Initialise an array channel
channels_list = []

# Initialise an array of videos
videos_list = []

# Initialise an array of celebrities
celebrities_list = []

# Utility functions

def empty_or_nil(string)
  string.empty? || string.nil?
end

def process(link_item, type, destination_array, position)
  if destination_array.include? link_item
    puts "Duplicate #{type} detected with link #{link_item} on the #{position}."
  else
    destination_array.push(link_item)
  end
end

# Go through the website from top to bottom
# Check if whatever we have found is already in a populated list

# First go through the carousel
carousel_items = parse_page.css('ul.carousel-list li.item')

carousel_items.each do |carousel_item|
  channel_link = carousel_item.css('a.vkal-track').first['href']
  process channel_link, 'channel', channels_list, 'carousel'
end

# Check the channels on the top left side bar
left_items = parse_page.css('div.l5 div.card-content ul li')

left_items.each do |left_item|
  if left_item.css('div.thumbnail-wrapper a').first
    channel_link = left_item.css('div.thumbnail-wrapper a').first['href']
    process channel_link, 'channel', channels_list, 'top left side bar'
  end
end

# Check the celebrities on the top left side bar
left_items.each do |left_item|
  left_item.css('div.s3 div.thumbnail-wrapper a').each do |celebrity_link|
    celebrity_link = celebrity_link['href']
    process celebrity_link, 'celebrity', celebrities_list, 'top left side bar'
  end
end

# Check trending now channels on the top middle column
trending_now_channels = parse_page.xpath('//ul[starts-with(@data-block-track, "popularList")]').css('a')

trending_now_channels.each do |trending_now_channel|
  channel_link = trending_now_channel['href']
  process channel_link, 'channel', channels_list, 'trending now middle column'
end

# Currently On Air
currently_on_air_channels = parse_page.xpath('//ul[starts-with(@data-block-track, "onAir")]').css('a')

currently_on_air_channels.each do |currently_on_air_channel|
  channel_link = currently_on_air_channel['href']
  process channel_link, 'channel', channels_list, 'currently on air middle column'
end

# Upcoming
upcoming_channels = parse_page.xpath('//ul[starts-with(@data-block-track, "upComing")]').css('a')

upcoming_channels.each do |upcoming_channel|
  channel_link = upcoming_channel['href']
  process channel_link, 'channel', channels_list, 'upcoming section middle column'
end

# Viki exclusives
viki_exclusive_items = parse_page.xpath('//div[contains(@data-block-track,"vikiExclusives")]').css('a')

viki_exclusive_items.each do |viki_exclusive_item|
  item_link = viki_exclusive_item['href']

  if item_link.include? '/tv/'
    process item_link, 'channel', channels_list, 'viki exclusive'
  elsif item_link.include? '/movies/'
    process item_link, 'video', videos_list, 'viki exclusive'
  end
end
