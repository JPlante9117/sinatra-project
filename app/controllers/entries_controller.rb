class EntriesController < ApplicationController
    get '/entries/new' do
        redirect_if_logged_out
        erb :'/entries/new'
    end

    get '/entries' do
        redirect_if_logged_out
        erb :'/entries/index'
    end

    post '/entries' do
        redirect_if_logged_out
        unless params.key?("species_list") && params[:species_list] != "select"
            if params[:species] == ""
                flash[:message] = "Please be sure to assign this entry to a Pokémon"
                redirect '/entries/new'
            else
                check_if_blank_content
                @entry = current_user.entries.build(content: params[:entry][:content])

                if pokemon = Pokemon.find_by(species: params[:species])
                    if pokemon.types.include?(params[:type1]) && pokemon.types.include?(params[:type2])
                        flash[:message] = "We assigned this entry to the existing Pokémon #{params[:species]}"
                        @entry.pokemon = pokemon
                    else
                        flash[:message] = "You listed an existing Pokémon with incorrect types. If this is a new variant, please 
                        enter again with '- {form here}' after the name so we may differentiate it."
                        redirect "/entries/new"
                    end
                else
                    @entry.pokemon = @entry.build_pokemon(species: params[:species], type1: params[:type1], type2: params[:type2])
                end
                if @entry.save
                    redirect "/entries/#{@entry.id}"
                else
                    flash[:message] = "Sorry, there was an issue creating your entry!"
                    redirect '/entries/new'
                end
            end
        else
            check_if_blank_content
            @entry = current_user.entries.build(content: params[:entry][:content], pokemon_id: params[:species_list], assistant_id: current_user.id)
            if @entry.save
                redirect "/entries/#{@entry.id}"
            else
                flash[:message] = "Sorry, there was an issue creating your entry!"
                redirect '/entries/new'
            end
        end
    end

    get '/entries/:id' do
        redirect_if_logged_out
        @entry = Entry.find_by_id(params[:id])
        erb :'/entries/show'
    end

    get '/entries/:id/edit' do
        redirect_if_logged_out
        @entry = Entry.find_by_id(params[:id])
        check_if_owned
        erb :'/entries/edit'
    end

    patch '/entries/:id' do
        redirect_if_logged_out
        @entry = Entry.find_by_id(params[:id])
        check_if_owned
        check_if_blank_content
        @entry.update(content: params[:entry][:content])
        if params[:species_list] != "select"
            @entry.pokemon.species = Pokemon.find_by(species: params[:species_list])
        else
            unless @entry.pokemon.species == params[:species] && params[:species_list] != "select"
                if pokemon = Pokemon.find_by(species: params[:species])
                    if pokemon.types.include?(params[:type1]) && pokemon.types.include?(params[:type2])
                        flash[:message] = "We assigned this entry to the existing Pokémon #{params[:species]}"
                        @entry.pokemon = pokemon
                    else
                        flash[:message] = "You listed an existing Pokémon with incorrect types. If this is a new variant, please 
                        enter again with '- {form here}' after the name so we may differentiate it."
                        redirect "/entries/#{@entry.id}/edit"
                    end
                else
                    @entry.pokemon = @entry.build_pokemon(species: params[:species], type1: params[:type1], type2: params[:type2])
                end
            end
        end
        @entry.save
        redirect "/entries/#{@entry.id}"
    end

    delete '/entries/:id/delete' do
        @entry = Entry.find_by_id(params[:id])
        redirect_if_logged_out
        check_if_owned
        @entry.delete
        flash[:message] = "Entry ##{@entry.id} has been deleted!"
        redirect "/entries"
    end
end