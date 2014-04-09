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
  
  def signed_in_employee
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def current_user=(employee)
    @current_user = employee
  end
  
  def current_user
    remember_token = Employee.hash(cookies[:remember_token])
    @current_user ||= Employee.find_by(remember_token: remember_token)
  end
  
  def sign_out
    current_user.update_attribute(:remember_token,Employee.hash(Employee.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
  
end
