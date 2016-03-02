class RoomController < ApplicationController
  require 'open-uri'
  require 'json'

  before_filter :authenticate_user!

  def index
  end

  def get_list
    rooms = Room.joins(:user).all
    ret = []

    joined_rooms = current_user.room_members.pluck(:room_id)

    rooms.each {|room|
      obj = {}
      obj[:id] = room.id
      obj[:user_name] = room.user.username
      obj[:destroyable] = false
      if room.user_id == current_user.id
        obj[:destroyable] = true
      end

      obj[:is_member] = false
      if joined_rooms.include?(room.id)
        obj[:is_member] = true
      end

      obj[:name] = room.name
      ret << obj
    }

    respond_to do |format|
      format.json {
        render :json => ret.to_json
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
    room.room_members.destroy_all
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

  def create_spell_from_wikipedia
    u = "https://ja.wikipedia.org/w/api.php?format=json&action=query&list=random&rnnamespace=0"
    u += "&rnlimit=" + SpellBingo::Application.config.spell_max.to_s

    room = Room.find(params[:id])

    res = open(u)
    code, message = res.status

    if code == '200'
      result = JSON.parse(res.read)
      query = result["query"]["random"]
      count = 0
      spells = room.spells

      spells.each {|spell|
        spell.name = query[count]["title"]
        count += 1
        spell.save
      }

    else
      logger.debug "create_spell_from_wikipedia:failed:" + u
    end

    respond_to do |format|
      format.json {
        ret = {'status' => 'succeed'}
        render :json => ret.to_json
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
