class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy 
  
  def index
    @users = User.paginate(:page => params[:page])
    @title = "All Users"
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign Up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to Twizilla!"}
    else
      @title = "Sign up"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit User"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #success
      redirect_to user_path(@user), :flash => { :success => "Successfully Updated."}
    else
      @title = "Edit User"
      render :edit
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, :flash => { :success => "Record Deleted."}
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to user_path(@user), 
      :flash => { :error => "Access denied, and this is the user's profile."} unless current_user?(@user)
    end
    
    def admin_user
      user = User.find(params[:id])
      redirect_to root_path, 
      :flash => { :error => "You do not have the permission to destroy an user record"} unless (current_user.admin? && !current_user?(user))
    end
end
