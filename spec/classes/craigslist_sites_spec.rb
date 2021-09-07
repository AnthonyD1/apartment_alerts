require 'rails_helper'

RSpec.describe CraigslistSites do
  describe '.refresh' do
    it 'writes sites to a yml file' do
      VCR.use_cassette('craigslist-sites') do
        expect(File).to receive(:write).with('craigslist_sites.yml', anything)
        described_class.refresh
      end
    end
  end

  context 'sites have already been pulled' do
    before do
      allow(YAML).to receive(:load_file).and_return(craigslist_sites)
    end

    describe '.sites' do
      it 'returns all cities by states with craigslist url' do
        expect(described_class.sites).to eq(craigslist_sites)
      end
    end

    describe '.cities' do
      it 'returns all cities with craigslist url' do
        expect(described_class.cities).to eq(craigslist_cities)
      end
    end

    describe '.cities_by_state' do
      it 'returns array of cities per state' do
        expect(described_class.cities_by_state).to eq(craigslist_cities_by_state)
      end
    end
  end

  private

  def craigslist_sites
    {
      "Alabama" =>
      {
        "auburn"=>"https://auburn.craigslist.org/",
        "birmingham"=>"https://bham.craigslist.org/",
        "dothan"=>"https://dothan.craigslist.org/",
        "florence / muscle shoals"=>"https://shoals.craigslist.org/",
        "gadsden-anniston"=>"https://gadsden.craigslist.org/",
        "huntsville / decatur"=>"https://huntsville.craigslist.org/",
        "mobile"=>"https://mobile.craigslist.org/",
        "montgomery"=>"https://montgomery.craigslist.org/",
        "tuscaloosa"=>"https://tuscaloosa.craigslist.org/"
      }
    }
  end

  def craigslist_cities
    {
      "auburn"=>"https://auburn.craigslist.org/",
      "birmingham"=>"https://bham.craigslist.org/",
      "dothan"=>"https://dothan.craigslist.org/",
      "florence / muscle shoals"=>"https://shoals.craigslist.org/",
      "gadsden-anniston"=>"https://gadsden.craigslist.org/",
      "huntsville / decatur"=>"https://huntsville.craigslist.org/",
      "mobile"=>"https://mobile.craigslist.org/",
      "montgomery"=>"https://montgomery.craigslist.org/",
      "tuscaloosa"=>"https://tuscaloosa.craigslist.org/"
    }
  end

  def craigslist_cities_by_state
    {
      "Alabama" =>
      [
        "auburn",
        "birmingham",
        "dothan",
        "florence / muscle shoals",
        "gadsden-anniston",
        "huntsville / decatur",
        "mobile",
        "montgomery",
        "tuscaloosa"
      ]
    }
  end
end
