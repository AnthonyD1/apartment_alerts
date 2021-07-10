RSpec.describe CraigslistQuery do
  require 'spec_helper'

  describe '#city' do
    it 'formats all caps properly' do
      city = 'DES MOINES'

      query = described_class.new(city: city)

      expect(query.city).to eq('desmoines')
    end

    it 'formats extra spaces proerly' do
      city = 'des moines  '

      query = described_class.new(city: city)

      expect(query.city).to eq('desmoines')
    end
  end

  around(:each) do |example|
    VCR.use_cassette('craigslist-success') do
      VCR.use_cassette('ip-address') do
        city = 'des moines'
        search_params = { hasPic: '1', max_price: '800' }

        @craigslist_query = described_class.new(city: city, search_params: search_params)
        example.run
      end
    end
  end

  describe '#parsed_html' do
    it 'returns Nokogiri parsed HTML' do
      parsed_html = @craigslist_query.parsed_html

      expect(parsed_html.class).to eq(Nokogiri::HTML::Document)
    end
  end

  describe '#posts' do
    it 'returns all posts' do
      expect(@craigslist_query.posts.count).to eq(120)
    end
  end
end
