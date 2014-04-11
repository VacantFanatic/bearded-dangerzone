class Event < ActiveRecord::Base
  ONE_DAY = 86400
  
  belongs_to :employee
  scope :start_range, lambda {|start_range| where("start_date >= ?", start_range)}
  scope :end_range, lambda {|end_range| where("start_date <= ?", end_range)}
  default_scope -> { order('start_date ASC') }
  default_scope -> { order('created_at DESC') }
  
  validate    :valid_start_date
  validates   :employee_id, presence: true
  validates   :start_date, presence: true
  validates   :end_date, presence: true 
  validate    :event_type, presence: true, inclusion: { in: %w(compressed vacation volunteer personal), message: "%{value} is not a valid type" }
  
  def valid_duration
    if self.event_type != "vacation" && self.duration > ONE_DAY
      errors.add(:end_date, "The selected event type cannot be longer than 24 hours")
    end
  end
  
  def valid_start_date
    events = Employee.find(employee_id).events
    events.each do |e| 
      if !dates_ordered? && !events_eq?(e) 
        errors.add(:start_date, "The start date must be less than the end date.")
      end
      if date_conflict?(e) && !events_eq?(e)
        errors.add(:start_date, "An event already exists for this period.")
      end
    end    
  end
  
  def dates_ordered?
    (self.end_date.end_of_day > self.start_date.beginning_of_day) 
  end
  
  def date_conflict?(event)
    event.start_date.beginning_of_day <= self.start_date && self.start_date < event.end_date.end_of_day
  end
  
  def events_eq?(event)
    event.id == self.id
  end
    
  def duration
    self.end_date - self.start_date
  end
  
end
