require 'rails_helper'

RSpec.describe CraigslistPost do
  context 'validations' do
    it 'is valid' do
      craigslist_post = build_stubbed(:craigslist_post)

      expect(craigslist_post).to be_valid
    end

    context 'presence' do
      it 'requires expected fields' do
        craigslist_post = described_class.new
        validated_fields = %i(post price date title link)

        craigslist_post.valid?

        expect(craigslist_post.errors.messages).to include(*validated_fields)
      end
    end
  end

  describe '#parsed_post' do
    it 'returns a Nokogiri object' do
      craigslist_post = described_class.new(post: 'Foobar')

      expect(craigslist_post.parsed_post.class).to eq(Nokogiri::XML::Document)
    end
  end

  describe '#update_deleted_at' do
    it 'sets deleted at' do
      craigslist_post = create(:craigslist_post, deleted_at: nil)

      expect(craigslist_post.update_deleted_at).to_not be(nil)
    end
  end
end
