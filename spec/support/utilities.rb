#IF YOU MODIFY THIS RESTART THE SPORK SERVER FOR TESTING!

def sign_in(employee, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = Employee.new_remember_token
    cookies[:remember_token] = remember_token
    employee.update_attribute(:remember_token, Employee.hash(remember_token))
  else
    visit signin_path
    
    fill_in "Userid",    with: employee.userid
    fill_in "Password", with: employee.password
    click_button "Sign in"
  end
end

def full_title(page_title)
  base_title = "STAFF Vacation Calendar"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end