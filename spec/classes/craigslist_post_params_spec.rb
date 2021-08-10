require 'rails_helper'
include Tor

RSpec.describe CraigslistPostParams do
  before do
    VCR.use_cassette('craigslist-success') do
      post = craigslist_posts.first

      @craigslist_post_params = described_class.new(post)
    end
  end

  describe '#call' do
    it 'returns craigslist posts params' do
      expected_params = [:post, :title, :link, :post_id, :date, :price, :hood, :bedrooms, :square_feet]

      expect(@craigslist_post_params.call.keys).to eq(expected_params)
    end
  end

  context 'params', :aggregate_failures do
    it 'is parsed correctly' do
      expect(@craigslist_post_params.title).to eq('Sweeping Skyline Views from Your Home, Dog Park, Custom Cabinetry')
      expect(@craigslist_post_params.link).to eq('https://desmoines.craigslist.org/apa/d/des-moines-sweeping-skyline-views-from/7335144880.html')
      expect(@craigslist_post_params.post_id).to eq(7335144880)
      expect(@craigslist_post_params.date).to eq(DateTime.parse('Sun 04 Jul 07:35:54 PM'))
      expect(@craigslist_post_params.price).to eq(726)
      expect(@craigslist_post_params.hood).to eq('')
    end

    describe '#bedrooms' do
      it 'returns nil when no housing info available' do
        allow(@craigslist_post_params).to receive_message_chain(:post, :css, :children, :first).and_return(nil)

        expect(@craigslist_post_params.bedrooms).to be_nil
      end

      it 'returns number of bedrooms when only bedroom info available' do
        allow(@craigslist_post_params).to receive_message_chain(:post, :css, :children, :first, :text).and_return("\n    3br -")

        expect(@craigslist_post_params.bedrooms).to eq(3)
      end

      it 'returns number of bedrooms when both bedroom and square feet available' do
        allow(@craigslist_post_params).to receive_message_chain(:post, :css, :children, :first, :text).and_return("\n    3br -\n    700ft")

        expect(@craigslist_post_params.bedrooms).to eq(3)
      end
    end

    describe '#square_feet' do
      it 'returns nil when no housing info available' do
        allow(@craigslist_post_params).to receive_message_chain(:post, :css, :children, :first).and_return(nil)

        expect(@craigslist_post_params.square_feet).to be_nil
      end

      it 'returns number of bedrooms when only bedroom info available' do
        allow(@craigslist_post_params).to receive_message_chain(:post, :css, :children, :first, :text).and_return("\n    700ft")

        expect(@craigslist_post_params.square_feet).to eq(700)
      end

      it 'returns number of bedrooms when both bedroom and square feet available' do
        allow(@craigslist_post_params).to receive_message_chain(:post, :css, :children, :first, :text).and_return("\n    3br -\n    700ft")

        expect(@craigslist_post_params.square_feet).to eq(700)
      end
    end
  end
end

def craigslist_posts
  parsed_html ||= Nokogiri::HTML(html)
  parsed_html.css('.result-info')
end

def html
  response = http.get(URI(search_url))
end

def search_url
  "https://desmoines.craigslist.org/search/apa?hasPic=1&max_price=800"
end
