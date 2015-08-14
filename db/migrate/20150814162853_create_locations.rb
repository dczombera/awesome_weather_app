class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :city,     index: true
      t.string :country , index: true
      t.float :latitude,  null: false
      t.float :longitude, null: false
      t.hstore :weather

      t.timestamps null: false
    end
  end
end
