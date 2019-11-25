require_relative './concerns/slugifiable.rb'

class Pokemon < ActiveRecord::Base
    has_many :entries
    has_many :assistants, through: :entries

    extend Slugifiable::ClassMethods

    def slug
        self.species.gsub(" ", "-").downcase
    end
end