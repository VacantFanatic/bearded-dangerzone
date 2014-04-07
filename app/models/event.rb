class Event < ActiveRecord::Base
  belongs_to :employee
  default_scope -> { order('start_date ASC') }
  default_scope -> { order('created_at DESC') }
  validates :employee_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :event_type, presence: true, inclusion: { in: %w(compressed vacation volunteer), message: "%{value} is not a valid size" }
end
