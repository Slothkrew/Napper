# spec/app_spec.rb
require File.expand_path '../../spec_helper.rb', __FILE__
require Dir.pwd << "/models/user.rb"
require "securerandom"

describe "The user class" do
  it "Should ensure unique username" do
    name = SecureRandom.hex

    create_user(name)

    expect {
      create_user(name)
    }.to change{ User.count }.by(0)
  end
end

def create_user(name)
  User.create({
    username:        name,
    password_digest: "a_password_goes_here"
    })
end