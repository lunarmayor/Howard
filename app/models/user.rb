class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, :phone, presence: true
  validates :email, :phone, uniqueness: {:case_sensitive => false}
  validates :password, length: {within: 8..20}

  before_create :set_password_confirmation
  before_create :format_phone_number

  def set_password_confirmation
    self.password_confirmation = self.password
  end

  def format_phone_number
    #format all phone numbers
  end
end
