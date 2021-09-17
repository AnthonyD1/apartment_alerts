RSpec.describe 'User' do
  context 'validations' do
    it 'is valid' do
      user = User.new(email: 'a@example.com', username: 'foo', password: 'password')

      expect(user).to be_valid
    end

    it 'requires a username' do
      user = User.new

      user.valid?

      expect(user.errors[:username]).to include("can't be blank")
    end
  end

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
