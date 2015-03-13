# spec/app_spec.rb
require File.expand_path '../spec_helper.rb', __FILE__

describe "My Sinatra Application" do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should reject registration unless you specify a username and password" do
    post "/register"
    expect(last_response.status).to eq 400
  end

  it "should allow you to register with a username and password" do
    post :register, { :username => "foo", :password => "bar" }
    redirects_to_index?
  end

  it "doesn't let you register an existing account" do
    new_name = SecureRandom.hex

    post :register, { :username => new_name, :password => "bar" }
    redirects_to_index?

    post :register, { :username => new_name, :password => "bar" }
    expect(last_response.status).to eq 400
  end
end