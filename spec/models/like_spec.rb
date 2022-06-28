require "rails_helper"

RSpec.describe Like, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
  end
  describe "Associations" do
    it { should belong_to(:user) }
    it { is_expected.to belong_to(:likeable) }
  end

  it { is_expected.to have_db_column(:likeable_id).of_type(:integer) }
  it { is_expected.to have_db_column(:likeable_type).of_type(:string) }
end
