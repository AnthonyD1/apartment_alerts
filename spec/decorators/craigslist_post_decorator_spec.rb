RSpec.describe CraigslistPostDecorator do
  before do
    post = CraigslistPost.new(
      price: 800,
      date: DateTime.parse('07/01/2021'),
      bedrooms: 2,
      square_feet: 900,
      hood: '(foo)'
    )

    @decorated_post = CraigslistPostDecorator.new(post)
  end

  describe '#price' do
    it 'is formatted as currency' do
      expect(@decorated_post.price).to eq('$800')
    end
  end

  describe '#date' do
    it 'is formatted correctly' do
      expected_date = DateTime.parse('07/01/2021').strftime("%m-%d-%Y %I:%M:%S %P")

      expect(@decorated_post.date).to eq(expected_date)
    end
  end

  describe '#bedrooms' do
    it 'is formatted correctly' do
      expect(@decorated_post.bedrooms).to eq('2 br')
    end

    it 'returns empty string when blank' do
      @decorated_post.model.bedrooms = nil

      expect(@decorated_post.bedrooms).to eq('')
    end
  end

  describe '#square_feet' do
    it 'is formatted correctly' do
      expect(@decorated_post.square_feet).to eq('900 ft')
    end

    context 'when nil' do
      it 'returns empty string' do
        @decorated_post.model.square_feet = nil

        expect(@decorated_post.square_feet).to eq('')
      end
    end
  end

  describe '#hood' do
    it 'is formatted correctly' do
      expect(@decorated_post.hood).to eq('Foo')
    end

    context 'when nil' do
      it 'returns empty string' do
        @decorated_post.model.hood = nil

        expect(@decorated_post.hood).to eq('')
      end
    end
  end
end
