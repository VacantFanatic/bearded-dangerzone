class Event < ActiveRecord::Base
  belongs_to :employee
  scope :start_range, lambda {|start_range| where("start_date > ?", start_range)}
  scope :end_range, lambda {|end_range| where("start_date < ?", end_range)}
  default_scope -> { order('start_date ASC') }
  default_scope -> { order('created_at DESC') }
  
  validate    :valid_start_date
  validates   :employee_id, presence: true
  validates   :start_date, presence: true
  validates   :end_date, presence: true 
  validate    :event_type, presence: true, inclusion: { in: %w(compressed vacation volunteer personal), message: "%{value} is not a valid type" }
  
  def valid_start_date
    events = Employee.find(employee_id).events
    test_date = start_date
    events.each do |e|
      if (e.start_date.beginning_of_day > test_date && test_date < e.end_date.end_of_day)
        errors.add(:start_date, "An event already exists for this period.")
      end
    end
    if (end_date < start_date)
      errors.add(:start_date, "The start date must be less than the end date.")
    end
  end
end
