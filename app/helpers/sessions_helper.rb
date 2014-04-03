module SessionsHelper
  def sign_in(employee)
    remember_token = Employee.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    employee.update_attribute(:remember_token, Employee.hash(remember_token))
    self.current_user = employee
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user=(employee)
    @current_user = employee
  end
  
  def current_user
    remember_token = Employee.hash(cookies[:remember_token])
    @current_user ||= Employee.find_by(remember_token: remember_token)
  end
  
end
