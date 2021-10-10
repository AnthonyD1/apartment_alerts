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

  describe '.batch_delete' do
    before do
      create(:craigslist_post)
    end

    it 'fixes counter culture counts' do
      expect(described_class).to receive(:counter_culture_fix_counts)

      described_class.batch_delete(described_class.all)
    end

    context 'when soft delete' do
      it 'does not actually delete posts' do
        described_class.batch_delete(described_class.all, soft_delete: true)

        expect(described_class.count).to eq(1)
        expect(described_class.active.count).to eq(0)
      end
    end

    context 'when hard delete' do
      it 'actually deletes post' do
        described_class.batch_delete(described_class.all, soft_delete: false)

        expect(described_class.count).to eq(0)
      end
    end
  end
end
