require_relative './concerns/slugifiable.rb'
class Assistant < ActiveRecord::Base
    has_secure_password
    has_many :entries
    has_many :pokemons, through: :entries

    validates_presence_of :name, :password

    extend Slugifiable::ClassMethods

    def slug
        self.name.gsub(" ", "-").downcase
    end
end