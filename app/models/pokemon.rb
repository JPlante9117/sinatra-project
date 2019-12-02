require_relative './concerns/slugifiable.rb'

class Pokemon < ActiveRecord::Base
    has_many :entries
    has_many :assistants, through: :entries

    extend Slugifiable::ClassMethods

    @@types = ["Normal", "Fire", "Water", "Electric", "Grass", "Ice", "Fighting", "Poison", "Ground", "Flying", "Psychic", "Bug", "Rock", "Ghost", "Dragon", "Steel", "Dark", "Fairy"]


    def slug
        self.species.gsub(" ", "-").downcase
    end

    def types
      ["#{self.type1}", "#{self.type2}"]
    end

    def self.types
      @@types
    end

    def coloredtable1
        type = @@types.find {|type| type == self.type1}
        case type
        when "Normal"
          "rgb(226, 226, 226)"
        when "Fire"
          "rgb(224, 91, 91)"
        when "Water"
          "rgb(91, 137, 224)"
        when "Electric"
          "rgb(231, 243, 127)"
        when "Grass"
          "rgb(137, 243, 127)"
        when "Ice"
          "rgb(157, 248, 248)"
        when "Fighting"
          "rgb(245, 159, 78)"
        when "Poison"
          "rgb(167, 114, 223)"
        when "Ground"
          "tan"
        when "Flying"
          "rgb(212, 211, 209)"
        when "Psychic"
          "rgb(218, 88, 207)"
        when "Bug"
          "rgb(173, 197, 117)"
        when "Rock"
          "rgb(160, 138, 96)"
        when "Ghost"
          "rgb(130, 100, 163)"
        when "Dragon"
          "rgb(79, 82, 238)"
        when "Fairy"
          "rgb(246, 128, 191)"
        when "Steel"
          "rgb(180, 180, 180)"
        when "Dark"
          "black"
        end
      end

      def coloredtable2
        type = @@types.find {|type| type == self.type2}
        case type
        when "Normal"
          "rgb(226, 226, 226)"
        when "Fire"
          "rgb(224, 91, 91)"
        when "Water"
          "rgb(91, 137, 224)"
        when "Electric"
          "rgb(231, 243, 127)"
        when "Grass"
          "rgb(137, 243, 127)"
        when "Ice"
          "rgb(157, 248, 248)"
        when "Fighting"
          "rgb(245, 159, 78)"
        when "Poison"
          "rgb(167, 114, 223)"
        when "Ground"
          "tan"
        when "Flying"
          "rgb(212, 211, 209)"
        when "Psychic"
          "rgb(218, 88, 207)"
        when "Bug"
          "rgb(173, 197, 117)"
        when "Rock"
          "rgb(160, 138, 96)"
        when "Ghost"
          "rgb(130, 100, 163)"
        when "Dragon"
          "rgb(79, 82, 238)"
        when "Fairy"
          "rgb(246, 128, 191)"
        when "Steel"
          "rgb(180, 180, 180)"
        when "Dark"
          "black"
        when "None"
            "rgb(245, 255, 211)"
        end
      end
end