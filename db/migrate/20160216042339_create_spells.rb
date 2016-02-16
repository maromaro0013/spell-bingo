class CreateSpells < ActiveRecord::Migration
  def change
    create_table :spells do |t|
      t.integer :room_id

      t.timestamps null: false
    end
  end
end
