class User < ApplicationRecord
  validates :username, presence: true
  has_many :alerts, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def guest?
    username == 'guest'
  end
end
