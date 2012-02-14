require 'spec_helper'

describe "LayoutLinks" do
  # testing the links on the layout
  it "should have the right links" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => 'About')
  end
end
