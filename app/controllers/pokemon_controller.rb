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
            binding.pry
            @pokemon = Pokemon.find_by_slug(params[:slug])
            erb :'/pokemon/show'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    helpers do
        
    end
end