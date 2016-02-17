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

    respond_to do |format|
      format.json {
        ret = {'status' => 'succeed'}
        render :json => ret
      }
    end
  end

  def destroy
    room = Room.find(params[:id])
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
    room = Room.find(params[:id])
    spell = room.spells.new()
    spell.save

    respond_to do |format|
      format.json {
        ret = {'status' => 'succeed'}
        render :json => ret
      }
    end
  end
end
