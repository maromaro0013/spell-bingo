class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :user_id
      t.string :name, limit: 32
      t.boolean :alive, default: true, null: false

      t.timestamps null: false
    end
  end
end
