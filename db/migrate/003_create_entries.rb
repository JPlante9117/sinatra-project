class CreateEntries < ActiveRecord::Migration[5.2]
    def change
        create_table :entries do |t|
            t.text :content
            t.integer :assistant_id
            t.integer :pokemon_id
        end
    end
end