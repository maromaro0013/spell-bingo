class RoomController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def get_list
    rooms = Room.select(:id, :user_id, :name, :created_at, :updated_at)

    respond_to do |format|
      format.json {
        render :json => rooms.to_json
      }
    end
  end

  def create
    room = Room.new(user_id: current_user.id)
    room.save
    room.name = "room" + room.id.to_s
    room.save

    spell_max = SpellBingo::Application.config.spell_max
    for num in (1..spell_max) do
      name = "spell" + num.to_s
      new_spell = Spell.new(room_id: room.id, name: name)
      new_spell.save
    end

    respond_to do |format|
      format.json {
        ret = {'status' => 'succeed'}
        render :json => ret
      }
    end
  end

  def destroy
    room = Room.find(params[:id])
    room.spells.destroy_all
    room.spell_sheets.destroy_all
    room.destroy

    respond_to do |format|
      format.json {
        ret = {'status' => 'succeed'}
        render :json => ret
      }
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def create_spell
    spell_max = SpellBingo::Application.config.spell_max
    room = Room.find(params[:id])
    status = ""
    if room.spells.count >= spell_max
      status = "failed"
    else
      status = "succeed"
      spell = room.spells.new(name: 'spell')
      spell.save
    end

    respond_to do |format|
      format.json {
        ret = {'status' => status}
        render :json => ret
      }
    end
  end

  def get_spells
    room = Room.find(params[:id])
    ret = room.spells.select(:id, :name)

    respond_to do |format|
      format.json {
        render :json => ret.to_json
      }
    end
  end
end
