class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :userid
      t.string :password_digest
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
