class Spell < ActiveRecord::Migration
  def change
    add_column :spells, :name, :string, default: ""
  end
end
