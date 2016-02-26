class CreateSpellSheets < ActiveRecord::Migration
  def change
    create_table :spell_sheets do |t|

      t.timestamps null: false
    end
  end
end
