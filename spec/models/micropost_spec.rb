require 'spec_helper'

describe Micropost do
  
  before(:each) do
    @user = Factory(:user)
    @attr = {:content => "Lorem ipsum dolor sit amet", :user_id => 1}
  end
  
  it "should create a new instance with valid attr" do
    @user.microposts.create!(@attr)
  end

  describe "user assosications" do
    
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end
    
    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end
    
    it "should have the right as" do
      @micropost.user_id.should eq(@user.id)
      @micropost.user.should eq(@user)
    end
    
  end






end
