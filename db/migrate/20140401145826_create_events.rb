class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :uid
      t.string :type
      t.datetime :startDate
     t.datetime :endDate
      t.timestamps
    end
  end
end
