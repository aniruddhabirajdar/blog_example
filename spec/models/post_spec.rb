require "rails_helper"

RSpec.describe Post, type: :model do
  subject {
    described_class.new(title: "Lorem ipsum",
                        body: "Lorem ipsum",
                        user_id: 1)
  }
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  describe "Associations" do
    it { should belong_to(:user) }
  end
  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
end
