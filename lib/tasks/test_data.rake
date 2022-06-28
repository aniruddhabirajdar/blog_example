require "faker"
namespace :test_data do
  desc "create data to test"
  task :dump => :environment do
    p "createing 20 random users"
    (0...20).each { |n| User.create({ user_name: Faker::Name.first_name }) }
    p "users has created #{User.count}"

    p "createing 40 random Posts"
    (0...40).each { |n| Post.create({ title: Faker::Lorem.sentence(word_count: rand(2..10)).chomp("."), body: Faker::Lorem.paragraphs(number: 1), user: User.all.sample }) }
    p "Post has created #{Post.count}"

    p "createing 80 random Comments"
    (0...80).each do |n|
      comment = Post.all.sample.comments.build({ body: Faker::Lorem.paragraphs(number: 1), user: User.all.sample })
      comment.save
    end
    p "Comment has created #{Comment.count}"

    p "createing 100 random Post likes"
    (0...100).each do |n|
      post = Post.all.sample
      like = post.likes.where(user: User.all.sample).first_or_initialize
      like.save
    end
    p "Post Like has created #{Like.count}"
    p "createing 100 random Comment likes"
    (0...100).each do |n|
      comment = Comment.all.sample
      like = comment.likes.where(user: User.all.sample).first_or_initialize
      like.save
    end
    p "Post Like has created #{Like.count}"
  end
end
