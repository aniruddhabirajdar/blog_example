require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "Create The Post" do
    context "with valid parameters" do
      before do
        post "/api/v1/posts", params: { post: {
                                title: "test title",
                                body: "test body",
                              } }
      end

      it "returns the title and body" do
        expect(JSON.parse(response.body)["title"]).to eq("test title")
        expect(JSON.parse(response.body)["body"]).to eq("test body")
      end
    end
  end

  describe "Create Post Comment" do
    context "with valid parameters" do
      before (:all) do
        @post_new = Post.create({ title: "test title", body: "test body", user: User.get_guest_user })
        post "/api/v1/posts/#{@post_new.id}/comments", params: { comment: {

                                                         body: "test body",
                                                       } }
      end

      it "returns the title and body" do
        expect(JSON.parse(response.body)["body"]).to eq("test body")
        expect(JSON.parse(response.body)["post_id"]).to eq(@post_new.id)
      end
    end
  end

  describe "Like the post " do
    context "with valid parameters" do
      before (:all) do
        @post_new = Post.create({ title: "test title", body: "test body", user: User.get_guest_user })
        post "/api/v1/posts/#{@post_new.id}/likes", params: {}
      end

      it "returns the title and body" do
        expect(JSON.parse(response.body)["likeable_id"]).to eq(@post_new.id)
        expect(JSON.parse(response.body)["likeable_type"]).to eq("Post")
      end
    end
  end

  describe "Like the post's commant  " do
    context "with valid parameters" do
      before (:all) do
        @post_new = Post.create({ title: "test title", body: "test body", user: User.get_guest_user })
        @comment = @post_new.comments.build({ body: "test body", user: User.get_guest_user })
        @comment.save
        post "/api/v1/comments/#{@comment.id}/likes", params: {}
      end

      it "returns the title and body" do
        expect(JSON.parse(response.body)["likeable_id"]).to eq(@comment.id)
        expect(JSON.parse(response.body)["likeable_type"]).to eq("Comment")
      end
    end
  end

  describe "GET post details " do
    before(:all) do
      @post = Post.create({ title: "test title", body: "test body", user: User.get_guest_user })
    end
    it "works! (now write some real specs)" do
      get api_v1_post_path(@post.id)
      expect(JSON.parse(response.body)["id"]).to eq(@post.id)
    end
  end
end
