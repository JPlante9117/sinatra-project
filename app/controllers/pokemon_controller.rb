class PokemonController < ApplicationController

    get '/pokemon' do
        #shows all pokemon!
        if logged_in?
            erb :'/pokemon/index'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    get '/pokemon/:slug' do
        #searches for pokemon by specific name
        if logged_in?
            #find specific pokemon
            erb :'/pokemon/show'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    helpers do
        def types
            ["Normal", "Fire", "Water", "Electric", "Grass", "Ice", "Fighting", "Poison", "Ground", "Flying", "Psychic", "Bug", "Rock", "Ghost", "Dragon", "Steel", "Dark", "Fairy"]
        end
    end
end