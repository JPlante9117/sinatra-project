class Pokemon < ActiveRecord::Base
    has_many :entries
    has_many :assistants, through: :entries
end