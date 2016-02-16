class RoomController < ApplicationController
  before_filter :authenticate_user!
end
