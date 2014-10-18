class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  phony_normalize :phone, :default_country_code => 'US'

  validates :email, :phone, presence: true
  validates :email, :phone, uniqueness: {:case_sensitive => false}
  validates :password, length: {within: 6..20}, unless: Proc.new { |user| user.password.nil? }
  validates :phone, :phony_plausible => true

  before_create :set_password_confirmation
  after_create :welcome_sms
  after_create :create_default_lists

  has_many :notes
  has_many :lists

  def remember_me
    true
  end

  def set_password_confirmation
    self.password_confirmation = self.password
  end

  def welcome_sms
    $nexmo.send_message(from: '12134657992', to: self.phone, text: 'Hello, I\'m Howard. Send me your ideas, notes, tasks, hopes, dreams, fears, and anything else you would like to get off your mind. I\'ll keep them safe.')
  end

  def create_default_lists
    self.lists.create(name: 'To do')
    self.lists.create(name: 'Life')
    self.lists.create(name: 'Work')
    self.lists.create(name: 'Done')
  end
end
