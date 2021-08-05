require 'rails_helper'

RSpec.describe CraigslistPost do
  context 'validations' do
    it 'is valid' do
      user = User.create(email: 'a@foo.com', username: 'foo', password: 'password')
      alert = Alert.create(name: 'Foobar',
                           city: 'des moines',
                           search_params: { hasPic: '1' },
                           user_id: user.id)
      craigslist_post = described_class.new(post: 'Foobar', alert_id: alert.id)

      expect(craigslist_post).to be_valid
    end

    describe 'post' do
      it 'does not add validation error when present' do
        craigslist_post = described_class.new(post: 'Foobar')

        craigslist_post.valid?

        expect(craigslist_post.errors.messages[:post]).to eq([])
      end

      it 'adds validation error when not present' do
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
