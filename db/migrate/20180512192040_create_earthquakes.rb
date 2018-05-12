class CreateEarthquakes < ActiveRecord::Migration[5.2]
  def change
    create_table :earthquakes do |t|
      t.string :usgs_id, index: true, null: false
      t.string :place
      t.string :city
      t.datetime :happened_at, index: true
      t.integer :timezone
      t.decimal :magnitude, scale: 2, precision: 4

      t.timestamps
    end
  end
end
