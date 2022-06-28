class Api::V1::CommentsController < Api::V1::ApiApplicationController
  before_action :set_comment, only: [:show]

  # GET /comments/1
  def show
    render json: @comment.to_json(methods: [:total_likes])
  end

  # POST /comments
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = @current_user

    if @comment.save
      render json: @comment.to_json(methods: [:total_likes]), status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end
