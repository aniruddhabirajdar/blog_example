require "rails_helper"

RSpec.describe User, type: :model do
  describe "Associations" do
    it { should have_many(:comments) }
    it { should have_many(:posts) }
    it { should have_many(:likes) }
  end

  it "should return true Guest User" do
    user = User.get_guest_user
    expect(user).to have_attributes(user_name: "GUEST")
  end
end
