class Room < ActiveRecord::Base
  has_many :room_members
end
