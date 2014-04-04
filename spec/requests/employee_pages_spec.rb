require 'spec_helper'

describe "Employee pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end
  
  describe "edit" do
    let(:employee) { FactoryGirl.create(:employee) }
    before do
      sign_in employee
      visit edit_employee_path(employee)
    end 
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      let(:new_userid) {"nxu001"}
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Userid",           with: new_userid
        fill_in "Password",         with: employee.password
        fill_in "Confirm Password", with: employee.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(employee.reload.name).to  eq new_name }
      specify { expect(employee.reload.email).to eq new_email }
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit employee") }
      #it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
  end
end
