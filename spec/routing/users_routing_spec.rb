require "rails_helper"

RSpec.describe "routing to users", :type => :routing do
  it "routes root url to users#index" do
    expect(get: "/users").to route_to(
      controller: "users",
      action: "index"
    )
  end

  it "routes /users/import to users#import" do
    expect(post: "/users/import").to route_to(
      controller: "users",
      action: "import"
    )
  end
end