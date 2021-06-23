RSpec.describe 'User' do
  describe '#guest?' do
    it 'returns true when User is a guest' do
      user = User.new(username: 'guest')

      expect(user).to be_guest
    end

    it 'returns false when User is not a guest' do
      user = User.new(username: 'Foobar')

      expect(user).to_not be_guest
    end
  end
end
