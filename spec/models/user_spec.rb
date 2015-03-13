# spec/app_spec.rb
require File.expand_path '../../spec_helper.rb', __FILE__
require Dir.pwd << "/app/models/user.rb"

describe "The user class" do
  it "Should ensure unique username" do
    name = SecureRandom.hex

    create_user(name)

    expect {
      create_user(name)
    }.to change{ User.count }.by(0)
  end

  it "should tell you if a username is available" do
    name = SecureRandom.hex

    expect(User.name_taken?(name)).to be_falsey

    create_user(name)

    expect(User.name_taken?(name)).to be_truthy
  end
end

def create_user(name)
  User.create({
    username:        name,
    password_digest: "a_password_goes_here"
    })
end