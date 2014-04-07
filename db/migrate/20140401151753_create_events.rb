class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string   :event_type
      t.datetime :start_date
      t.datetime :end_date
      t.integer :employee_id
      t.timestamps
    end
    add_index :events, [:employee_id, :created_at]
  end
end
