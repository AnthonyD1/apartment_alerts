RSpec.describe AlertDecorator do
  describe '#search_param_tags' do
    it 'returns params excluding postedToday' do
      alert = Alert.new(city: 'des moines', search_params: { hasPic: '1', postedToday: '1' })

      alert_decorator = alert.decorate

      expect(alert_decorator.search_param_tags).to eq({ hasPic: '1' })
    end
  end
end
