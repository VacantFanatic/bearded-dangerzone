class Employee < ActiveRecord::Base
  has_many :Events
end
