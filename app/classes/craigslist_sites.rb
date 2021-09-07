class CraigslistSites
  def self.refresh
    tmp_states = parsed_html.at_css('.colmask').css('h4').map(&:text)
    tmp_cities = parsed_html.at_css('.colmask').css('ul').map do |ul|
      city = {}
      ul.css('a').each { |li| city[li.text] =  li['href']}
      city
    end
    tmp_sites = {}

    tmp_states.each_with_index do |state, i|
      tmp_sites[state] = tmp_cities[i]
    end

    File.write('craigslist_sites.yml', tmp_sites.to_yaml)
  end

  def self.sites
    YAML.load_file('craigslist_sites.yml')
  rescue
    nil
  end

  def self.states
    sites.try(:keys)
  end

  def self.cities
    sites.values.reduce({}, :merge) if sites.present?
  end

  def self.cities_by_state
    return if sites.blank?

    tmp_cities = sites.values.map(&:keys)
    tmp = {}
    states.each_with_index do |state, i|
      tmp[state] = tmp_cities[i]
    end
    tmp
  end

  class << self
    include Tor

    private

    def parsed_html
      @parsed_html ||= Nokogiri::HTML.parse(html)
    end

    def site_url
      "https://www.craigslist.org/about/sites"
    end

    def html
      p '*' * 100
      p http.get(URI('https://ipinfo.io/ip'))
      p '*' * 100

      response = http.get(URI(site_url))

      p '*' * 100
      p response.size
      p '*' * 100

      if ip_blocked?(response)
        generate_new_tor_circuit
        sleep(5)
        self.html
      else
        return response
      end
    end

    def ip_blocked?(response)
      response.size < 300
    end
  end
end
