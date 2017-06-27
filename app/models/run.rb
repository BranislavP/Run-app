class Run < ApplicationRecord

  validates :distance, :duration, :date, :user_id, presence: true
  validates :distance, numericality: {greater_than_or_equal_to: 0}

  belongs_to :user

end
