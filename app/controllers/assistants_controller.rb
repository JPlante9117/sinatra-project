class AssistantsController < ApplicationController
    
    get '/assistants' do
        if logged_in?
            erb :'/assistants/index'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

    get '/signup' do
        if logged_in?
            flash[:message] = "You're already logged in and don't need to sign up!"
            redirect '/'
        else
            erb :'/assistants/new'
        end
    end

    post '/signup' do
        if logged_in?
            flash[:message] = "You are already logged in and don't need to sign up!"
            redirect '/'
        else
            if params[:name] == "" || params[:password] == ""
                flash[:message] = "Please make sure each section is properly filled in"
                redirect '/signup'
            elsif Assistant.find_by(name: params[:name])
                flash[:message] = "There is already an employee by that name, please select another name, or sign in if you already have an account"
                redirect '/signup'
            else
                @assistant = Assistant.new(:name => params[:name], :password => params[:password])
                @assistant.save
                session[:user_id] = @assistant.id
                redirect to '/'
            end
        end
    end

    get '/login' do
        if logged_in?
            flash[:message] = "You are already logged in"
            redirect '/'
        else
            erb :'/assistants/login'
        end
    end

    post '/login' do
        if logged_in?
            flash[:message] = "You are already logged in"
            redirect '/'
        else
            assistant = Assistant.find_by(name: params[:name])
            if assistant && assistant.authenticate(params[:password])
                session[:user_id] = assistant.id
                redirect '/'

            elsif assistant
                flash[:message] = "Name and password do not match, please try again"
                redirect '/login'
            else
                flash[:message] = "Couldn't find an account with that information! Sign up today!"
                redirect '/signup'
            end
        end
    end

    get '/logout' do
        if logged_in?
            session.clear
            flash[:message] = "You have logged out"
            redirect '/'
        else
            flash[:message] = "You are not logged in and therefore cannot sign out."
            redirect '/'
        end
    end

    get '/assistants/:slug' do
        if logged_in?
            @assistant = Assistant.find_by_slug(params[:slug])
            erb :'/assistants/show'
        else
            flash[:message] = "I'm sorry, our research is quite confidential! Please prove you work for us by signing in!"
            redirect '/login'
        end
    end

end