class CreateGroupPlaces < ActiveRecord::Migration
  def self.up
    create_table :group_places do |t|
      t.integer :group_id
      t.integer :place_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_places
  end
end
