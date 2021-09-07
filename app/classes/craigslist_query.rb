class CraigslistQuery
  include Tor

  attr_accessor :city
  attr_accessor :search_params

  def initialize(params)
    @city = params[:city]
    @search_params = params[:search_params]
  end

  def parsed_html
    @parsed_html ||= Nokogiri::HTML(html)
  end

  def posts
    non_duplicate_non_nearby_posts.map do |post|
      CraigslistPost.new(CraigslistPostParams.new(post).call)
    end
  end

  private

  def nearby_area_node_index
    node = parsed_html.css('.rows').children.css('.ban.nearby').first
    parsed_html.css('.rows').children.find_index(node)
  end

  def non_duplicate_non_nearby_posts
    return non_duplicate_posts if nearby_area_node_index.blank?
    return [] if nearby_area_node_index < 2

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
    "#{CraigslistSites.cities[city]}search/apa?"
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
    p '*' * 100
    p http.get(URI('https://ipinfo.io/ip'))
    p '*' * 100

    response = http.get(URI(search_url))

    p '*' * 100
    p response.size
    p '*' * 100
   
    if ip_blocked?(response)
      return response
    else
      generate_new_tor_circuit
      sleep(5)
      self.html
    end
  end

  def ip_blocked?(response)
    response.size > 300
  end
end
