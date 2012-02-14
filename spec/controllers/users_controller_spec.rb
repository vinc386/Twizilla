require 'spec_helper'

describe UsersController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
  end
  
  describe "GET :show" do
    
    it "should show the user page" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name )
    end
    
    it "should have an avatar" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => 'gravatar')
    end
    
    it "should have the right URL" do
      get :show, :id => @user
      response.should have_selector('div>a', :content => user_path(@user),
                                            :href => user_path(@user))
    end
  end
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector('title', :content => 'Sign Up')
    end

  end
  
  describe "POST 'create" do
    
    describe "sign-up failure" do
      before(:each) do
        @attr = {
          :name => '',
          :email =>'',
          :password => '',
          :password_confirmation => ''
        }
      end
      
      # it "should have the right title"
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
      it "should not create the new user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
    end
    
    describe "sign-up success" do
      before(:each) do
        @attr = {
          :name => 'foobar',
          :email =>'vincent.yang@jgospel.net',
          :password => 'foobar',
          :password_confirmation => 'foobar'
        }
      end
      
      it "should create a new user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to user 'show' page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should flash a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to twizilla/i
      end
      
      it "should sign in the user after s/he registered" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end
  
  
  
end
