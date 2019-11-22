class Assistant < ActiveRecord::Base
    has_many :entries
    has_many :pokemons, through: :entries
end