class Room < ActiveRecord::Base
  has_many :room_members
  has_many :spells
end
