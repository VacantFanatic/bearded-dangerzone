class SessionsController < ApplicationController
  def new
    
  end

  def create
   employee = Employee.find_by(userid: params[:session][:userid].downcase)
    if employee && employee.authenticate(params[:session][:password])
      sign_in employee
      redirect_to employee
    else
      flash[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
  end
end
