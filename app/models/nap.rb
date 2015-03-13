require 'data_mapper'

class Nap
  include DataMapper::Resource
  property :id,     Serial
  property :body,   String, :required => true
  property :author, String, :required => true
  property :posted, DateTime

  def posted_date
    if posted
      if DateTime.now.to_s.include? Date.today.to_s
        posted.strftime("%T")
      else
        posted.strftime("%T %d/%m/%Y")
      end
    else
      "In the past"
    end
  end
end