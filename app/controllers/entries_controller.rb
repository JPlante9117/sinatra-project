class EntriesController < ApplicationController
    get '/entries/new' do
        if logged_in?
            erb :'/entries/new'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    get '/entries' do
        if logged_in?
            erb :'/entries/index'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    post '/entries' do
        if logged_in?
            unless params.key?("species_list") && params[:species_list] != "select"
                if params[:species] == ""
                    flash[:message] = "Please be sure to assign this entry to a Pokémon"
                    redirect '/entries/new'
                else
                    if params[:type2] == params[:type1]
                        params[:type2] = "None"
                    end
                    if params[:entry][:content] == ""
                        flash[:message] = "Please refrain from creating blank entries"
                        redirect '/entries/new'
                    else
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
                end
            else
                if params[:entry][:content] == ""
                    flash[:message] = "Please refrain from creating blank entries"
                    redirect '/entries/new'
                else
                    @entry = current_user.entries.build(content: params[:entry][:content], pokemon_id: params[:species_list], assistant_id: current_user.id)
                    if @entry.save
                        redirect "/entries/#{@entry.id}"
                    else
                        flash[:message] = "Sorry, there was an issue creating your entry!"
                        redirect '/entries/new'
                    end
                end
            end
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    get '/entries/:id' do
        if logged_in?
            @entry = Entry.find_by_id(params[:id])
            erb :'/entries/show'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    get '/entries/:id/edit' do
        if logged_in?
            @entry = Entry.find_by_id(params[:id])
            if current_user == @entry.assistant
                erb :'/entries/edit'
            elsif current_user != @entry.assistant
                flash[:message] = "Sorry, please refrain from trying to edit entries that aren't yours."
                redirect "/entries/#{@entry.id}"
            end
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    patch '/entries/:id' do
        if logged_in?
            @entry = Entry.find_by_id(params[:id])
            if current_user == @entry.assistant
                if params[:entry][:content] == ""
                    flash[:message] = "Please refrain from creating blank entries"
                    redirect "/entries/#{@entry.id}/edit"
                else
                    @entry.update(content: params[:entry][:content])
                    if params[:species_list] != "select"
                        @entry.pokemon.species = Pokemon.find_by(species: params[:species_list])
                    else
                        unless @entry.pokemon.species == params[:species] && params[:species_list] != "select"
                            if params[:type2] == params[:type1]
                                params[:type2] = "None"
                            end
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
                end
            else
                flash[:message] = "Please refrain from trying to edit entries that are not yours."
                redirect "/entries/#{@entry.id}"
            end
            redirect "/entries/#{@entry.id}"
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    delete '/entries/:id/delete' do
        @entry = Entry.find_by_id(params[:id])
        if logged_in?
            if current_user == @entry.assistant
                @entry.delete
                flash[:message] = "Entry ##{@entry.id} has been deleted!"
                redirect "/entries"
            else
                flash[:message] = "Please refrain from trying to delete entries that are not yours."
                redirect "/entries/#{@entry.id}"
            end
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end
end