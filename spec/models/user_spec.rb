# spec/app_spec.rb
require File.expand_path '../../spec_helper.rb', __FILE__
require Dir.pwd << "/models/user.rb"
require "securerandom"

describe "The user class" do
  it "Should ensure unique username" do
    name = SecureRandom.hex

    User.create({
      username:        name,
      password_digest: "derp"
      })

    expect {
      User.create({
        username:        name,
        password_digest: "derp"
        })
    }.to change{ User.count }.by(0)
  end
end