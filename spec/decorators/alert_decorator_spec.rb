require 'rails_helper'

RSpec.describe AlertDecorator do
  describe '#search_param_tags' do
    it 'returns params excluding postedToday' do
      search_params = HashWithIndifferentAccess.new({ hasPic: '1', postedToday: '1' })
      alert = Alert.new(city: 'des moines', search_params: search_params)

      alert_decorator = alert.decorate

      expect(alert_decorator.search_param_tags).to eq(['has pics'])
    end

    it 'formats boolean tags properly' do
      search_params = HashWithIndifferentAccess.new({ pets_dog: '1' })
      alert = Alert.new(city: 'des moines', search_params: search_params)

      alert_decorator = alert.decorate

      expect(alert_decorator.search_param_tags).to eq(['dog friendly'])
    end

    it 'formats regular tags properly' do
      search_params = HashWithIndifferentAccess.new({ search_distance: '10' })
      alert = Alert.new(city: 'des moines', search_params: search_params)

      alert_decorator = alert.decorate

      expect(alert_decorator.search_param_tags).to eq(['search distance: 10'])
    end

    context 'compound tags' do
      it 'formats square feet correctly' do
        search_params = HashWithIndifferentAccess.new({ minSqft: '100', maxSqft: '600' })
        alert = Alert.new(city: 'des moines', search_params: search_params)

        alert_decorator = alert.decorate

        expect(alert_decorator.search_param_tags).to eq(['Sqft: 100 - 600'])
      end

      it 'formats price correctly' do
        search_params = HashWithIndifferentAccess.new({ min_price: '100', max_price: '600' })
        alert = Alert.new(city: 'des moines', search_params: search_params)

        alert_decorator = alert.decorate

        expect(alert_decorator.search_param_tags).to eq(['price: 100 - 600'])
      end
    end
  end

  describe '#next_pull_time_remaining' do
    it 'returns the time remaining until next pull in minutes' do
      alert = Alert.new
      allow(alert).to receive(:next_pull_time).and_return(DateTime.current.utc + 10.minutes)

      alert_decorator = alert.decorate

      expect(alert_decorator.next_pull_time_remaining).to eq(10)
    end
  end

  describe '#total_matches_found' do
    it 'returns correct phrase' do
      alert = Alert.new(craigslist_posts_count: 2)

      alert_decorator = alert.decorate

      expect(alert_decorator.total_matches_found).to eq('Total matches found: 2')
    end
  end
end
