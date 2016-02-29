class SpellSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  belongs_to :spell

  def SpellSheet.delete_sheets(user:, room:)
    self.destroy_all(user_id: user.id, room_id: room.id)
  end

  def SpellSheet.create_sheets(user:, room:)
    self.delete_sheets(user: user, room: room)
    user_id = user.id
    spell_max = SpellBingo::Application.config.spell_max

    spells = Spell.where(room_id: room.id).pluck(:id)
    if (spells.count != spell_max)
      raise "error spells_count"
    end
    spells.shuffle!

    spells.each{|value|
      append = self.new(user_id: user_id, room_id: room.id, spell_id: value)
      append.save
    }
  end

  def push_spell
    self.pushed = 1
    self.save
  end
end
