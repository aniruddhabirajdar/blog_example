class Post < ApplicationRecord
  include Likeable
  has_many :comments
  belongs_to :user
  validates :title, :body, presence: true

  def report
    {
      post_id: self.id,
      comment_count: self.comments.count,
      likes_count: self.total_likes,
    }
  end
end
