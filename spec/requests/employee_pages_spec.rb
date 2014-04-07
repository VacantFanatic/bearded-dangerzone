require 'spec_helper'

describe "Employee pages" do

  subject { page }

  describe "index" do
    let(:employee) { FactoryGirl.create(:employee) }
    before(:each) do
      sign_in employee
      visit employees_path
    end

    it { should have_title('All employees') }
    it { should have_content('All employees') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:employee) } }
      after(:all)  { Employee.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        Employee.paginate(page: 1).each do |employee|
          expect(page).to have_selector('li', text: employee.name)
        end
      end
    end
    
    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit employees_path
        end

        it { should have_link('delete', href: employee_path(Employee.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(Employee, :count).by(-1)
        end
        it { should_not have_link('delete', href: employee_path(admin)) }
      end
    end
    
  end

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

    describe "profile page" do
      let(:employee) { FactoryGirl.create(:employee) }
      let!(:e1) { FactoryGirl.create(:event, employee: employee, event_type: "Compressed") }
      let!(:e2) { FactoryGirl.create(:event, employee: employee, event_type: "Vacation") }

      before { visit employee_path(employee) }

      it { should have_content(employee.name) }
      it { should have_title(employee.name) }

      describe "events" do
        it { should have_content(e1.event_type) }
        it { should have_content(e2.event_type) }
        it { should have_content(employee.events.count) }
      end
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
  
    describe "forbidden attributes" do
      let(:params) do
        { employee: { admin: true, password: employee.password,
                      password_confirmation: employee.password } }
      end
      before do
        sign_in employee, no_capybara: true
        patch employee_path(employee), params
      end
      specify { expect(employee.reload).not_to be_admin }
    end
  end
end
