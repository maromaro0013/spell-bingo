class Spell < ActiveRecord::Base
  has_one :room
end
