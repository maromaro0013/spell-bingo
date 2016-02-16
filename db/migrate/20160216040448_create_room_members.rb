class CreateRoomMembers < ActiveRecord::Migration
  def change
    create_table :room_members do |t|
      t.integer :room_id
      t.integer :user_id
      t.boolean :alive, default: true, null: false

      t.timestamps null: false
    end
  end
end
