class GameController < ApplicationController
  def index
    room = Room.find params[:room_id]

    # シートを持っていない人は必ずシート作成する
    if (current_user.spell_sheets.where(room_id: room.id).count <= 0)
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
      obj[:sheet_id] = value.id
      obj[:spell_id] = value.spell_id
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

  def toggle_sheet
    sheet = SpellSheet.find params[:sheet_id]
    if (sheet.pushed == false)
      sheet.pushed = true
    else
      sheet.pushed = false
    end
    sheet.save

    ret = {}
    ret[:status] = "succeed"
    respond_to do |format|
      format.json {
        render :json => ret
      }
    end
  end

  def quit
    room_id = params[:room_id]

    member = current_user.room_members.where(room_id: room_id)
    member.destroy_all

    sheets = current_user.spell_sheets.where(room_id: room_id)
    sheets.destroy_all

    ret = {}
    ret[:status] = "succeed"
    respond_to do |format|
      format.json {
        render :json => ret
      }
    end
  end


  def members_info
    room_id = params[:room_id]
    room = Room.find(room_id)

    members = room.room_members.select(:user_id)
    ret = {}
    ret[:status] = "succeed"
    ret[:members] = []

    bingo_progress = get_bingo_progress(user: current_user, room_id: room_id)
    ret[:members] << bingo_progress

    respond_to do |format|
      format.json {
        render :json => ret.to_json
      }
    end
=begin
    members.each {|member|
      member_info = {}
      member_info[:user_name] = member.user.username
    }
=end
  end

  private
  def get_bingo_progress(user:, room_id:)
    ret = {}

    sheets = user.spell_sheets.where(room_id: room_id)
    ret[:pushed_count] = sheets.where(pushed: true).count

    bingo_table = [
      [0, 1, 2, 3, 4],
      [5, 6, 7, 8, 9],
    ]

    return ret
  end
end
