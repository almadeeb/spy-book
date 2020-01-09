class LikesController < ApplicationController
  def create
    type = type_subject?(params)
    @subject = Post.find(params[:post_id]) if type == 'post'
    @subject = Comment.find(params[:comment_id]) if type == 'comment'
    if already_liked?(type)
      dislike(type)
    else
      @like = @subject.likes.build(user_id: current_user.id)
      if @like.save
        flash[:success] = "#{type} liked!"
        redirect_to users_path
      else
        flash[:danger] = "#{type} like failed!"
        redirect_to users_path
      end
    end
  end

  private

  # Returns the subject being liked (comment or post)
  def type_subject?(params)
    type = 'post' if params.key?('post_id')
    type = 'comment' if params.key?('comment_id')

    type
  end

  # Dislike the liked comment or post
  def dislike(type)
    @like = Like.find_by(post_id: params[:post_id]) if type == 'post'
    @like = Like.find_by(comment_id: params[:comment_id]) if type == 'comment'
    @like.destroy
    redirect_to users_path
  end

  # Returns whether a post or comment has already been liked by the current_user signed in
  def already_liked?(type)
    result = false
    if type == 'post'
      result = Like.where(user_id: current_user.id, post_id:
      params[:post_id]).exists?
    end
    if type == 'comment'
      result = Like.where(user_id: current_user.id, comment_id:
      params[:comment_id]).exists?
    end

    result
  end
end
