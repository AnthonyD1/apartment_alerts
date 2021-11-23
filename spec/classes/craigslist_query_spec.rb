require 'rails_helper'

RSpec.describe CraigslistQuery do
  context 'when url suffix ends in .org/' do
    around(:each) do |example|
      VCR.use_cassette('craigslist-success') do
        city = 'des moines'
        search_params = { hasPic: '1', max_price: '800' }

        @craigslist_query = described_class.new(city: city, search_params: search_params)
        example.run
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

  context 'when url suffix does not end in .org/' do
    it 'properly formats the url and returns posts' do
      VCR.use_cassette('craigslist-weird-suffix-success') do
        city = 'miami / dade'
        search_params = { hasPic: '1' }

        craigslist_query = described_class.new(city: city, search_params: search_params)

        expect(craigslist_query.posts.count).to eq(120)
      end
    end
  end
end
