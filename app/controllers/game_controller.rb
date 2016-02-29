class GameController < ApplicationController
  def index
    room = Room.find params[:room_id]

    # シートを持っていない人は必ずシート作成する
    if (current_user.spell_sheets.count <= 0)
      SpellSheet.create_sheets(user: current_user, room: room)
    end
    # 初入場の場合はRoomMemberを新たに作成
    if (current_user.room_members.where(room_id: room.id).count <= 0)
      RoomMember.new(room_id: room.id, user_id: current_user.id).save
    end
  end

  def info
    room = Room.find params[:room_id]
    spells = current_user.spell_sheets.where(room_id: room.id).joins(:spell)
    ret = {}
    ret[:spells] = []
    ret[:spell_max] = SpellBingo::Application.config.spell_max
    ret[:spell_row_max] = SpellBingo::Application.config.spell_row_max
    ret[:spell_col_max] = SpellBingo::Application.config.spell_col_max
    ret[:spell_center] = SpellBingo::Application.config.spell_center

    spells.each {|value|
      obj = {}
      obj[:pushed] = value.pushed
      obj[:name] = value.spell.name
      ret[:spells] << obj
    }

    ret[:status] = "succeed"

    respond_to do |format|
      format.json {
        render :json => ret
      }
    end
  end
end
