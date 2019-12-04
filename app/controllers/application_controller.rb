require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "ShhThisIsSecret"
    register Sinatra::Flash
  end
  
  get '/' do
    erb :welcome
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= Assistant.find_by_id(session[:user_id]) if session[:user_id]
    end

    def redirect_if_logged_out
      if !logged_in?
        flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
        redirect '/login'
      end
    end

    def redirect_if_logged_in
      if logged_in?
        flash[:message] = "You are already logged in and don't need to access this function!"
        redirect '/'
      end
    end

    def check_if_owned
      if current_user != @entry.assistant
        flash[:message] = "Please refrain from trying to alter entries that are not yours."
        redirect "/entries/#{@entry.id}"
      end
    end

    def check_if_blank_content
      if params[:entry][:content] == ""
        flash[:message] = "Please refrain from creating blank entries"
        if @entry
          redirect "/entries/#{@entry.id}/edit"
        else
          redirect "/entries/new"
        end
      end
    end

  end

end