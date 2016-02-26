class SpellSheet < ActiveRecord::Migration
  def change
    create_table :spell_sheets do |t|
      t.integer :user_id
      t.integer :room_id
      t.integer :spell_id
      t.integer :sort, auto_increment: true
      t.boolean :pushed, default: false, null: false

      t.timestamps null: false
    end
  end
end
