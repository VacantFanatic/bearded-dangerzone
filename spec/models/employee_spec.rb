require 'spec_helper'

describe Employee do
  
  before do
    @employee = Employee.new(name: "Example User", email: "user@example.com", userid: "123456", password: "foobar", password_confirmation: "foobar")
  end

  subject { @employee }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:userid) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:events) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @employee.save!
      @employee.toggle!(:admin)
    end

    it { should be_admin }
  end


  it { should be_valid }

    describe "return value of authenticate method" do
      before { @employee.save }
    
      let(:found_user) { Employee.find_by(email: @employee.email) }

      describe "with valid password" do
        it { should eq found_user.authenticate(@employee.password) }
      end

      describe "with invalid password" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid") }

        it { should_not eq user_for_invalid_password }
        specify { expect(user_for_invalid_password).to be_false }
      end
    end
  
  describe "when name is not present" do
    before { @employee.name = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @employee.email = " " }
    it { should_not be_valid }
  end
  
  describe "when userid is not present" do
    before { @employee.userid = " " }
    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before do
      @employee = Employee.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @employee.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @employee.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @employee.email = invalid_address
        expect(@employee).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @employee.email = valid_address
        expect(@employee).to be_valid
      end
    end
  end
  
  describe "when user ID address is already taken" do
    before do
      user_with_same_userid = @employee.dup
      user_with_same_userid.email = @employee.email.upcase
      user_with_same_userid.save
    end
    it { should_not be_valid }
  end
  
    describe "with a password that's too short" do
      before { @employee.password = @employee.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end
  describe "remember token" do
    before { @employee.save }
    its(:remember_token) { should_not be_blank }
  end
  
  describe "event associations" do

    before { @employee.save }
    let!(:older_event) do
      FactoryGirl.create(:event, employee: @employee, start_date: 14.days.from_now, end_date: 30.days.from_now, created_at: 1.day.ago)
    end
    let!(:newer_event) do
      FactoryGirl.create(:event, employee: @employee, start_date: 3.days.from_now, end_date: 120.days.from_now, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@employee.events.to_a).to eq [newer_event, older_event]
    end
  end
  
end

