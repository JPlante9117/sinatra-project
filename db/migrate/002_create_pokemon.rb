class CreatePokemon < ActiveRecord::Migration[5.2]
    def change
        create_table :pokemons do |t|
            t.string :species
            t.string :type1
            t.string :type2
        end
    end
end