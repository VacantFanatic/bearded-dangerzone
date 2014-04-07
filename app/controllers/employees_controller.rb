class EmployeesController < ApplicationController
  before_action :signed_in_employee,   only: [:index, :edit, :update, :destroy]
  before_action :correct_user,         only: [:edit, :update]
  before_action :set_employee,         only: [:show, :edit, :update, :destroy]
  before_action :admin_user,           only: :destroy

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.paginate(page: params[:page])
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    @employee = Employee.find(params[:id])
    @events = @employee.events.paginate(page: params[:page])
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)
    if @employee.save
 #     sign_in @employee
      flash[:success] = "Welcome #{@employee.name}!"
      redirect_to @employee
    else
      render 'new'
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    if @employee.update_attributes(employee_params)
      flash[:success] = "Profile updated"
      redirect_to @employee
    else
      render 'edit'
    end
  end
  

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    Employee.find(params[:id]).destroy
    flash[:success] = "Employee deleted."
    redirect_to employees_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      if current_user.admin?
          params.require(:employee).permit(:name, :email,:userid,:password,:password_confirmation, :admin)
      else
          params.require(:employee).permit(:name, :email,:userid,:password,:password_confirmation)     
      end
    end
  
  # Before filters
  def signed_in_employee
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @employee = Employee.find(params[:id])
      redirect_to(root_url) unless current_user?(@employee)
    end
  
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
