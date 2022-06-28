class Api::V1::LikesController < Api::V1::ApiApplicationController
  # POST /comments
  def create
    @likable = likable
    @like = @likable.likes.where(user: @current_user).first_or_initialize

    if @like.save
      render json: @like, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  def likable
    return Post.find params[:post_id] if params[:post_id]
    Comment.find params[:comment_id] if params[:comment_id]
  end
end
