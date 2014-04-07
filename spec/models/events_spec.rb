require 'spec_helper'

describe Event do

  let(:employee) { FactoryGirl.create(:employee) }
  before {@event = employee.events.build(event_type: "Test")}

  subject { @event }

  it { should respond_to(:event_type)   }
  it { should respond_to(:employee_id) }
  it { should respond_to(:employee) }
  its(:employee) { should eq employee }
  it { should respond_to(:start_date)  }
  it { should respond_to(:end_date)    }
  
  describe "when user_id is not present" do
    before { @event.employee = nil }
    it { should_not be_valid }
  end

  describe "with no event type" do
    before { @event.event_type = nil }
    it { should_not be_valid }
  end
  
  describe "with an invalid event type" do
    before { @event.event_type = "Overtime" }
    it { should_not be_valid }
  end

  describe "no start date" do
    before { @event.start_date = nil }
    it { should_not be_valid }
  end
  
  describe "no end date" do
    before { @event.end_date = nil }
    it { should_not be_valid }
  end


  
end