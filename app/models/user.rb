class User < ApplicationRecord 
  attr_reader :password
  validates :password_digest, :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :session_token, presence: true
  
  after_initialize :ensure_session_token
  
  has_many :cats,
    foreign_key: :user_id,
    class_name: 'Cat'
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end
  
  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end
  
  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end
  
  def self.find_by_credentials(user_name,pw)
    user = User.find_by(username: user_name)
    return nil if user.nil?
    user.is_password?(pw) ? user : nil
  end
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end
end 