require 'spec_helper'

describe Micropost do
  
  before(:each) do
    @user = Factory(:user)
    @attr = {:content => "Lorem ipsum dolor sit amet"}
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

  describe "validations" do
    
    it "should have the user id" do
      Micropost.new(@attr).should_not be_valid
    end
    
    it "should require non-blank content" do
      @user.microposts.build(:content => '       ').should_not be_valid
    end
    
    it "should reject content that is too long" do
      @user.microposts.build(:content => 'a' * 141).should_not be_valid
    end
  end




end
