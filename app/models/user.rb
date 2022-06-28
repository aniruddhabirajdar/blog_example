class User < ApplicationRecord
  has_many :comments
  has_many :posts
  has_many :likes

  def self.get_guest_user
    User.where(user_name: "GUEST").first
  end

  def like_comment_report
    ActiveRecord::Base.connection.execute("SELECT  post_id , SUM(comment_count) as comment_count, SUM(like_count) as like_count FROM( SELECT  posts.user_id, posts.id as post_id , count(comments.id) as comment_count, 0 like_count FROM posts LEFT OUTER  JOIN comments on comments.post_id = posts.id GROUP BY(posts.id) UNION SELECT  posts.user_id, posts.id as post_id, 0 comment_count, count(likes.id) as  like_count FROM posts LEFT OUTER  JOIN likes on likes.likeable_id = posts.id AND likes.likeable_type = 'Post' GROUP BY(posts.id)) CountsTable GROUP BY CountsTable.post_id HAVING user_id = #{self.id}")
  end

  def self.post_count_report_sql
    ActiveRecord::Base.connection.execute("SELECT  users.id as user_id,count(users.id) as number_of_posts FROM users INNER JOIN  posts on posts.user_id = users.id  GROUP BY(users.id) HAVING count(users.id) > 0 ")
  end

  def self.post_count_report
    User.select("users.id,COUNT(users.id) as number_of_posts").joins(:posts).group("users.id").having("count(users.id) > 0").map(&:as_json)
  end
end
