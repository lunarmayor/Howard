class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, :name, :phone, presence: true
  validates :email, :phone, uniqueness: {:case_sensitive => false}
  validates :password, length: {within: 8..20}
end
