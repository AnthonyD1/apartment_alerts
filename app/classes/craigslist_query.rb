class CraigslistQuery
  include Tor

  attr_accessor :city
  attr_accessor :search_params

  def initialize(params)
    @city = parsed_city(params)
    @search_params = params[:search_params]
  end

  def parsed_html
    @parsed_html ||= Nokogiri::HTML(html)
  end

  def posts
    non_duplicate_non_nearby_posts.map do |post|
      CraigslistPost.new(post: post)
    end
  end

  private

  def parsed_city(params)
    params[:city].downcase.strip.delete(' ')
  end

  def nearby_area_node_index
    node = parsed_html.css('.rows').children.css('.ban.nearby').first
    parsed_html.css('.rows').children.find_index(node)
  end

  def non_duplicate_non_nearby_posts
    # Divide by 2 to account for the newline nodes
    last_non_nearby_post = (nearby_area_node_index / 2) - 1
    non_duplicate_posts[0..last_non_nearby_post]
  end

  def non_duplicate_posts
    parsed_html.css('.result-info') - parsed_html.xpath('//ul[@class="duplicate-rows"]').css('.result-info')
  end

  def duplicate_posts
    parsed_html.xpath('//ul[@class="duplicate-rows"]').css('.result-info')
  end

  def base_url
    "https://#{city}.craigslist.org/search/apa?"
  end

  def search_url
    base_url + search_params_string
  end

  def search_params_string
    search = ''
    search_params.each do |param|
      search << param.first.to_s
      search << '='
      search << param.last.to_s
      search << '&'
    end
    search
  end

  def html
    response = http.get(URI(search_url))

    p '*' * 100
    p response.size
    p http.get(URI('https://ifconfig.me'))
    p '*' * 100
   
    if ip_blocked?(response)
      return response
    else
      generate_new_tor_circuit
      self.html
    end
  end

  def ip_blocked?(response)
    response.size > 300
  end
end
