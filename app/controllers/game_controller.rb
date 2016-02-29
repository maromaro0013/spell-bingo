class GameController < ApplicationController
  def index
    room_id = params[:room_id]
    room = Room.find room_id

    # シートを持っていない人は必ずシート作成する
    if (current_user.spell_sheets.count <= 0)
      SpellSheet.create_sheets(user: current_user, room: room)
    end
    # 初入場の場合はRoomMemberを新たに作成
    if (current_user.room_members.where(room_id: room_id).count <= 0)
      RoomMember.new(room_id: room_id, user_id: current_user.id).save
    end
  end
end
