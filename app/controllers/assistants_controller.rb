class AssistantsController < ApplicationController
    
    get '/assistants' do
        if logged_in?
            erb :'/assistants/index'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
    end

    get '/signup' do
        if logged_in?
            flash[:message] = "You're already logged in and don't need to sign up!"
            redirect '/entries'
        else
            erb :'/assistants/new'
        end
    end

    post '/signup' do
        
        if params[:name] == "" || params[:password] == ""
            flash[:message] = "Please make sure each section is properly filled in"
            redirect '/signup'
        else
            @assistant = Assistant.new(:name => params[:name], :password => params[:password])
            @assistant.save
            session[:user_id] = @assistant.id
            redirect to '/entries'
        end
    end

    get '/login' do
        if logged_in?
            flash[:message] = "You are already logged in"
            redirect '/entries'
        else
            erb :'/assistants/login'
        end
    end

    post '/login' do
        assistant = Assistant.find_by(name: params[:name])
        if assistant && assistant.authenticate(params[:password])
            session[:user_id] = assistant.id
            redirect '/entries'
        else
            flash[:message] = "Couldn't find an account with that information! Sign up today!"
            redirect '/signup'
        end
    end

    get '/logout' do
        if logged_in?
            session.clear
            flash[:message] = "You have logged out"
            redirect '/'
        else
            redirect '/'
        end
    end

    get '/assistants/:slug' do
        @assistant = assistant.find_by_slug(params[:slug])
        erb :'/assistants/show'
    end

end