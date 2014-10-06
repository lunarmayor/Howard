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
  after_create :welcome_sms

  has_many :notes
  has_many :lists

  def remember_me
    true
  end

  def set_password_confirmation
    self.password_confirmation = self.password
  end

  def format_phone_number
    #format all phone numbers
  end

  def welcome_sms
    $nexmo.send_message(from: '12134657992', to: self.phone, text: 'Hello, I\'m Howard. Send me your ideas, notes, tasks, hopes, dreams, fears, and anything else you would like to get off your mind. I\'ll keep them safe.')

  end
end
