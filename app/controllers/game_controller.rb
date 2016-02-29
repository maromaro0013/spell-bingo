class GameController < ApplicationController
  def index
    room_id = params[:room_id]
    room = Room.find room_id

    # シートを持っていない人は必ずシート作成する
    if (current_user.spell_sheets.count <= 0)
      SpellSheet.create_sheets(user: current_user, room: room)
    end

  end
end
