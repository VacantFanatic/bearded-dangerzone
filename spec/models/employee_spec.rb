require 'spec_helper'

describe Employee do

  before do
    @employee = Employee.new(name: "Example User", email: "user@example.com", uid: "123456"
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @employee }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:uid) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when name is not present" do
    before { @employee.name = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @employee.email = " " }
    it { should_not be_valid }
  end
  
  describe "when UID is not present" do
    before { @employee.uid = " " }
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
      user_with_same_UID = @employee.dup
      user_with_same_UID.email = @employee.email.upcase
      user_with_same_UID.save
    end
    it { should_not be_valid }
  end
  
end

