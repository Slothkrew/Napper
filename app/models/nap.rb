require 'data_mapper'

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