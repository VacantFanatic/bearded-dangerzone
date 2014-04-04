class SessionsController < ApplicationController
  def new
    
  end

  def create
    employee = Employee.find_by(userid: params[:session][:userid].downcase)
    if employee && employee.authenticate(params[:session][:password])
      sign_in employee
      redirect_back_or employee
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
