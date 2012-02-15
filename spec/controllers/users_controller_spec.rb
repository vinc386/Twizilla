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
      assigns(:user).should == @user #assign(:sym) takes a symbol and get an instance var from the cotroller
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
  
  
  
  describe "GET 'edit'" do

    before(:each) do
      test_sign_in @user
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it " should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Edit User" ) 
    end
    
    it "should have a link to change the user's gravatar" do
      get :edit, :id => @user
      response.should have_selector('a', :href => 'http://gravatar.com/emails',
                                          :content => "change")
    end
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      test_sign_in(@user)
    end
    
    describe "failure" do
      before(:each) do
        @attr = {
          :name => '',
          :email =>'',
          :password => '',
          :password_confirmation => ''
        }
      end
    
      it "should render the 'edit' page" do
        put :update, :user => @attr, :id => @user 
        response.should render_template(:edit)
      end
      
      it "should have the right title" do
        put :update, :user => @attr, :id => @user 
        response.should have_selector('title', :content => "Edit User")
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {
          :name => 'New Name',
          :email =>'New_Email@email.com',
          :password => 'NewPassword',
          :password_confirmation => 'NewPassword'
        }
      end
      
      it " update the user's attributes" do
        put :update, :id => @user, :user => @attr #this @user is the Factory user
        user = assigns(:user)
        @user.reload #pull the new user attributes from database
        @user.name.should eq user.name
        @user.email.should eq user.email
        @user.encrypted_password.should eq user.encrypted_password
      end
      
      it "should flash a message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end
  
  describe "authenticate of edit/update actions" do
    
    describe "for users that are not signed in" do
      it "should reuqire user to sign in before editing" do
        get :edit, :id => @user
        response.should redirect_to signin_path
        flash[:notice].should =~ /sign in/i
      end
    
      it "should reuqire user to sign in before updating" do
        put :update, :id => @user, :user => {} #need this empty user hash to match the route
        response.should redirect_to signin_path
        flash[:notice].should =~ /sign in/i
      end
    end
    describe "for users that are signed in" do
      before(:each) do
        wrong_user = Factory(:user, :email => "not_the@sameuser.com")
        test_sign_in(wrong_user)
      end
      
      it "should require matching user for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(user_path(@user))
      end
      
      it "should require matching user for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(user_path(@user))
      end
    end
  end
  
  
end
