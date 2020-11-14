class CraigslistQuery
  require 'nokogiri'
  require './craigslist_post.rb'

  attr_accessor :city

  def initialize(params)
    @city = params[:city]
  end

  def parsed_html
    @parsed_html ||= Nokogiri::HTML(html)
  end

  def posts
    parsed_html.css('.result-info').map do |post|
      CraigslistPost.new(post)
    end
  end

  private

  def base_url
    "https://#{city}.craigslist.org/search/apa?"
  end

  def search_url
    base_url
  end

  def html
    `torify curl #{base_url}`
  end
end
