class AddIndexToEmployeesUid < ActiveRecord::Migration
  def change
    add_index :employees, :userid, unique: true
  end
end
