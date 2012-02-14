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
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Sign In"
    response.should have_selector('title', :content => "Sign In")
    click_link "Home"
    response.should have_selector('title', :content => "Twizilla")
  end
end
