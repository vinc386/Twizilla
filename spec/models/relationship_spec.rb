require 'spec_helper'

describe Relationship do

    before(:each) do
      @follower = Factory(:user)
      @followed = Factory(:user, :email => Factory.next(:email))
      @attr = { :followed_id => @followed.id }
    end

    it "should create a new instance with valid attr" do
      @follower.relationships.create!(@attr)
    end
    
    describe ":follow" do
      
      before(:each) do
        @relationships = @follower.relationships.create!(@attr)
      end
      
      it "should have a follower attribute" do
        @relationships.should respond_to(:follower)
      end
      
      it "should have the right follower" do
        @relationships.follower.should == @follower
      end
      
      it "should have a followed attribute" do
        @relationships.should respond_to(:followed)
      end
      
      it "should have the right followed" do
        @relationships.followed.should == @followed
      end
    end
    
    describe "validations" do
      it "should require a follower id" do
        Relationship.new(@attr).should_not be_valid
      end
      
      it "should require a followed id" do
        @follower.relationships.build.should_not be_valid
      end
    end
end
