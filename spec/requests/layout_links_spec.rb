require 'spec_helper'

describe "LayoutLinks" do
  # testing the routes with this integration test
  it "should have a path for 'home'" do
    get '/'
    response.should be_success
  end
  
  it "should have a path for 'contact'" do
    get '/contact'
    response.should be_success
  end
  
  it "should have a path for 'about'" do
    get '/about'
    response.should be_success
  end
  
  it "should have a path for 'sign up'" do
    get '/signup'
    response.should be_success
  end
  
  # testing the links on the layout
  # it "should have the right links" do
  #   visit root_path
  #   click_link "About"
  #   response.should have_selector('title', :content => 'About')
  # end
end
