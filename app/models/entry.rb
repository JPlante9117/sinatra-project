class Entry < ActiveRecord::Base
    belongs_to :assistant
    belongs_to :pokemon
end