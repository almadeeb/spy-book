class FriendshipsController < ApplicationController
  # Creates friend request
  def create
    @friendrequest = current_user.friendsent.build(sent_to_id: params[:user_id])
    if @friendrequest.save
      flash[:success] = "Friend Request sent!"
    else
      flash[:danger] = "Friend Request could not be sent!"
    end
    redirect_back(fallback_location: root_path)
  end

  def acceptFriend
    @friendrequest = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id)
    if @friendrequest
      @friendrequest.status = true
      if @friendrequest.save
        flash[:success] = "Friend Request Accepted!"
        redirect_back(fallback_location: root_path)
      else
        flash[:danger] = "Friend Request could not be accepted!"
      end
    end
  end

  def declineFriend
    @friendrequest = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id)

    @friendrequest.destroy
    flash[:warning] = 'Successfully Removed friend'
    redirect_back(fallback_location: root_path)
  end
end
