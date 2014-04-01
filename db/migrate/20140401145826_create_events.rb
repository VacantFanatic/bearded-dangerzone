class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :uid
      t.string :type
      t.DateTime :startDate
      t.DateTime :endDate

      t.timestamps
    end
  end
end
