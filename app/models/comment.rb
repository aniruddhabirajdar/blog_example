class Comment < ApplicationRecord
  include Likeable
  belongs_to :post
  belongs_to :user

  validates :body, presence: true
end
