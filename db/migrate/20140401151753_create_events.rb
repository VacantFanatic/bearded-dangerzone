class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :type
      t.datetime :start
      t.datetime :end
      t.string :uid

      t.timestamps
    end
  end
end
