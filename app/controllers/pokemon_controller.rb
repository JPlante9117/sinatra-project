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

    get '/pokemon/types' do
        if logged_in?
            erb :'/pokemon/types_index'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    get '/pokemon/types/:slug' do
        if logged_in?
            @type = params[:slug]
            @pokemon = Pokemon.all.select {|poke| poke.type1 == @type.capitalize || poke.type2 == @type.capitalize}
            erb :'/pokemon/types_show'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    get '/pokemon/:slug' do
        #searches for pokemon by specific name
        if logged_in?
            @pokemon = Pokemon.find_by_slug(params[:slug])
            @entries = @pokemon.entries
            erb :'/pokemon/show'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end
end