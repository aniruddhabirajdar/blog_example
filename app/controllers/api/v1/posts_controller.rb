class Api::V1::PostsController < Api::V1::ApiApplicationController
  before_action :set_post, only: [:show]

  # GET /posts
  def index
    @posts = Post.all

    render json: { posts: @posts.as_json(include: [{ comments: { methods: :total_likes } }], methods: [:total_likes]), totla_posts: Post.all.count }
  end

  # GET /posts/1
  def show
    render json: @post.to_json(include: [{ comments: { methods: :total_likes } }], methods: [:total_likes])
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user = @current_user

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
