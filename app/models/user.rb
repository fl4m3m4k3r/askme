require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  attr_accessor :password

  has_many :questions, dependent: :destroy
  has_many :author_questions, class_name: 'Question', foreign_key: :author_id, dependent: :nullify

  before_validation :downcase_username_and_email
  before_save :encrypt_password

  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true

  validates :username, length: { maximum: 40 }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/ }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, on: :create, presence: true
  validates :password, confirmation: true

  validates :profile_color, format: /\A#([[:xdigit:]]){3,6}\z/

  def self.authenticate(email, password)
    user = find_by(email: email&.downcase)

    if user.present? && user.password_hash == User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def encrypt_password
    if self.password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  def downcase_username_and_email
    username&.downcase!
    email&.downcase!
  end
end
