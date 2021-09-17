require 'rails_helper'

RSpec.describe CraigslistPost do
  context 'validations' do
    it 'is valid' do
      craigslist_post = build_stubbed(:craigslist_post)

      expect(craigslist_post).to be_valid
    end

    context 'presence' do
      it 'requires post' do
        craigslist_post = described_class.new(post: nil)

        craigslist_post.valid?

        expect(craigslist_post.errors.messages[:post]).to eq(["can't be blank"])
      end
    end
  end

  describe '#parsed_post' do
    it 'returns a Nokogiri object' do
      craigslist_post = described_class.new(post: 'Foobar')

      expect(craigslist_post.parsed_post.class).to eq(Nokogiri::XML::Document)
    end
  end
end
