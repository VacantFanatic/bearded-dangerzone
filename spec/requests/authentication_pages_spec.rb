require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end
  
  describe "signin" do
    before { visit signin_path }
    
    describe "with invalid information" do
      let(:employee) { FactoryGirl.create(:employee) }
      before { sign_in employee }

      it { should have_title(employee.name) }
      it { should have_link('Employees',       href: employees_path) }
      it { should have_link('Profile',     href: employee_path(employee)) }
      it { should have_link('Settings',    href: edit_employee_path(employee)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid information" do
      let(:employee) { FactoryGirl.create(:employee) }
      
      before { sign_in employee }
      
      it { should have_title(employee.name) }
      it { should have_link('Profile',     href: employee_path(employee)) }
      it { should have_link('Settings',    href: edit_employee_path(employee)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
      
      it { should have_title(employee.name) }
      it { should have_link('Profile',     href: employee_path(employee)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      
    end
  end
  
  describe "authorization" do
    describe "for non-signed-in employees" do
      
      let(:employee) { FactoryGirl.create(:employee) }
      
      describe "when attempting to visit a protected page" do
        before do
          visit edit_employee_path(employee)
          fill_in "Userid",      with: employee.userid
          fill_in "Password",   with: employee.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            print page.html
            expect(page).to have_title('Edit employee')
          end
        end
      end
      
      describe "in the employees controller" do
        
        describe "visiting the edit page" do
          before { visit edit_employee_path(employee) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch employee_path(employee) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end
  
    describe "as wrong employee" do
      let(:employee) { FactoryGirl.create(:employee) }
      let(:wrong_employee) { FactoryGirl.create(:employee, email: "wrong@example.com", userid: "wxe001") }
      before { sign_in employee, no_capybara: true }

      describe "submitting a GET request to the employees#edit action" do
        before { get edit_employee_path(wrong_employee) }
        specify { expect(response.body).not_to match(full_title('Edit employee')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the employees#update action" do
        before { patch employee_path(wrong_employee) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end 
end
