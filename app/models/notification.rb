class Notification < ApplicationRecord

	self.table_name = :notifications
  default_scope { where(is_deleted: false) }
  scope :not_readed, -> {where(is_read: false)}
  belongs_to :recipient, :foreign_key => 'recipient_id'
  validates :subject, :message, presence: true
end
