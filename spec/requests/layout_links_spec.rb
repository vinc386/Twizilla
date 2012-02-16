require 'spec_helper'

describe "LayoutLinks" do
  # testing the routes with this integration test
  it "should have a path for 'home'" do
    get '/'
    response.should have_selector('title', :content => "Twizilla")
  end
  
  it "should have a path for 'contact'" do
    get '/contact'
    response.should have_selector("title", :content => "Contact", )
  end
  
  it "should have a path for 'about'" do
    get '/about'
    response.should have_selector("title", :content => 'About')
  end
  
  it "should have a path for 'sign up'" do
    get '/signup'
    response.should have_selector('title', :content => 'Sign Up')
  end
  
  it "should have a path for sign in" do
    get '/signin'
    response.should have_selector('title', :content => "Sign In")
  end
  
  # testing the links on the layout
  it "should have the right links" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => 'About')
    # click_link "Contact"
    # response.should have_selector('title', :content => "Contact")
    click_link "Sign In"
    response.should have_selector('title', :content => "Sign In")
    click_link "Home"
    response.should have_selector('title', :content => "Twizilla")
  end
  
  describe "when not signed in" do
    it "should have a sign in link" do
      get root_path
      response.should have_selector("a", :href => signin_path,
                                          :content => "Sign In")
    end
  end
  
  describe "when signed in" do
  
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email,     :with => @user.email
      fill_in :password,  :with => @user.password
      click_button
    end
  
    it "should have a sign out link" do
      visit root_path
      response.should have_selector("a", :content => "Sign Out")
    end
    
    it "should have a profile link" do
      visit root_path
      response.should have_selector('a', :href => user_path(@user), :content => "Profile")
    end
    
    it "should have a settings link" do
      visit root_path
      response.should have_selector('a', :href => edit_user_path(@user), :content => "Settings")
    end
    
    it "should have a userers link" do
      visit root_path
      response.should have_selector('a', :href => users_path, :content => "Users")
    end
  end
  
  
  
end
