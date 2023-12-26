class User < ApplicationRecord
  has_secure_password
  enum role: [:hr_manager, :manager, :employee]
  validates(
    :role, presence: true
  )
  validates :email, presence: true, uniqueness: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }



   def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save
  end           
end
