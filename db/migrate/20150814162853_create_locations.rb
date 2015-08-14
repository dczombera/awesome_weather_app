class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :city, null: false, index: true
      t.string :country , null: false, index: true
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.hstore :weather

      t.timestamps null: false
    end
  end
end
