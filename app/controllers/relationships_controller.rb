class RelationshipsController < ApplicationController
  before_filter :authenticate
  
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to @user
    
    # respond_to do |format|
    #   format.html { redirect_to @user }
    #   format.js
    #   # this is like a switch statement
    #   # only one of the lines will be run
    # end

  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to @user
    
    # respond_to do |format|
    #   format.html { redirect_to @user }
    #   format.js
    # end
  end
end