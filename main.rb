require 'sinatra'
require 'bcrypt'
require 'data_mapper'

enable :sessions, :logging
set :session_secret, 'ultra buttes'

@env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/#{@env}.db")
Dir["models/*.rb"].each {|file| require "#{Dir.pwd}/#{file}" }

DataMapper.finalize

get '/' do
  @naps = Nap.all(:order => [ :id.desc ]) || {}
  erb :welcome, layout: :main
end

get '/sloths' do
  @sloths = User.all || {}
  erb :sloths
end

get '/register' do
  erb :register
end

post '/register' do
  halt(400) unless params[:username] && params[:password]

  unless user_exists?(params[:username])
    User.create({
      username:        params[:username],
      password_digest: params[:password]
      })
  else
    halt(400)
  end

  redirect "/"
end

def user_exists?(username)
  User.first(username: params[:username])
end

def logged_in?
  session[:username]
end

post '/login' do
  user = User.first(username: params[:username])
  if user
    password = BCrypt::Password.new(user.password_digest)
    if password == params[:password]
      session[:username] = params[:username]
    end
  end
  redirect "/"
end

get '/logout' do
  session[:username] = nil
  redirect "/"
end

post '/nap' do
  Nap.create({
    body:   params[:body],
    author: session[:username],
    posted: DateTime.now
    })

  redirect "/"
end
