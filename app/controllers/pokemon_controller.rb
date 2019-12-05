class PokemonController < ApplicationController

    get '/pokemon' do
        redirect_if_logged_out
        erb :'/pokemon/index'
    end

    get '/pokemon/types' do
        redirect_if_logged_out
        erb :'/pokemon/types_index'
    end

    get '/pokemon/types/:slug' do
        redirect_if_logged_out
        @type = params[:slug]
        @pokemon = Pokemon.where(type1: @type.capitalize).or(Pokemon.where(type2: @type.capitalize))
        erb :'/pokemon/types_show'
    end

    get '/pokemon/:slug' do
        redirect_if_logged_out
        @pokemon = Pokemon.find_by_slug(params[:slug])
        @entries = @pokemon.entries
        erb :'/pokemon/show'
    end
end