class SpellSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  belongs_to :spell

  def SpellSheet.delete_sheets(user:, room:)
    self.destroy_all(user_id: user.id, room_id: room.id)
  end

  def SpellSheet.create_sheets(user:, room:)
    self.delete_from_user(user: user)
    user_id = user.id
    spell_max = SpellBingo::Application.config.spell_max

    spells = Spell.where(room_id: room.id).pluck
    if (spells.count != spell_max)
      raise "error spells_count"
    end
    spells.shuffle!

    spells.each{|key, value|
      logger.debug "mokyun" + value.to_s
    }
  end
end
