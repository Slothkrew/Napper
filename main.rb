require 'sinatra'
require 'data_mapper'
require 'dm-types'
require 'bcrypt'

enable :sessions, :logging
set :session_secret, 'ultra buttes'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Nap
  include DataMapper::Resource
  property :id,     Serial
  property :body,   String, :required => true
  property :author, String, :required => true
  property :posted, DateTime

  def posted_date
    posted.strftime("%T %d/%m/%Y") if posted
  end
end

class User
  include DataMapper::Resource
  property :id,              Serial
  property :username,        String,     :required => true
  property :password_digest, BCryptHash, :required => true

  validates_uniqueness_of :username
end

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
  unless user_exists?(params[:username])
    puts "registrating"
    User.create({
      username:        params[:username],
      password_digest: params[:password]
      })
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
