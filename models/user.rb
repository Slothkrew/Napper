require 'data_mapper'
require 'dm-types'

class User
  include DataMapper::Resource
  property :id,              Serial
  property :username,        String,     :required => true
  property :password_digest, BCryptHash, :required => true

  validates_uniqueness_of :username
end