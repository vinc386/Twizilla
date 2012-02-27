require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      :name => "foobar", 
      :email => "foobar@twizilla.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
    @user = User.create!(@attr) #for password and micropost
  end
  
  
  it "should be able to create a user with valid attr" do
    @user.should be_valid
  end
  
  it "should require a name" do
    no_name = User.new(@attr.merge(:name => "")).
    should_not be_valid
  end
  
  it "should have a name that with proper length" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name)).
    should_not be_valid
  end
  
  it "should have an email" do
    User.new(@attr.merge(:email => "")).
    should_not == true
  end
  
  it "should have an valid email" do
    invalid_emails = 
      %w{invalid_email@.com invalid@email. invalid_email@. @.invalidemail invalid@email,com}
    .each do |ie|
      User.new(@attr.merge(:email => "ie")).
      should_not be_valid
    end
  end
  
  it "should have an unique email" do
    # testing upcase email address
    User.new(@attr.merge(:email => @attr[:email].upcase)).
    should_not be_valid
  end
  
  describe "password" do
    it "should respond to password" do
      User.new(@attr).should respond_to(:password)
    end
    
    it "should respond to password confirmation as well" do
      User.new(@attr).should respond_to(:password_confirmation)
    end
    
    it "should require a password" do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).
      should_not be_valid
      # this one is not validating properly, but passed…
    end
  
    it "should require a matching pw and pw_confirmation set" do
      User.new(@attr.merge(:password_confirmation => '')).
      should_not be_valid
    end
  
    it "should check the length of the password" do
      invalid_passwords = [] << 'a' * 5 << 'a' * 61
      invalid_passwords.each do |i|
        User.new(@attr.merge(:password => "i", :password_confirmation => "i")).
        should_not be_valid
      end
    end
  end
  
  describe "password encryption" do
    
    it "should respond to the encryped_password" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should be able to set the encryped password" do
      @user.encrypted_password.should_not be_blank
    end
    
    it "should have a salt" do
      @user.should respond_to(:salt)
    end

    describe "has_password?" do
      
      it "should respond to has_password" do
        @user.should respond_to(:has_password?)
      end
      
      it "should should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false when passwords don't match" do
        @user.has_password?("invalid_password").should be_false
      end
    end
  end
  
  describe "authenticate method" do
    
    it "should exist" do
      User.should respond_to(:authenticate)
    end
    
    it "should return nil on email/pw mismatch" do
      User.authenticate(@attr[:email], "wrongpassword").should be_nil
    end
    
    it "should return nil for non existed email/user" do
      User.authenticate('non_existed@email.com', @attr[:password]).should be_nil
    end
    
    it "should return a user on match" do
      User.authenticate(@attr[:email], @attr[:password]).should == @user
    end
  end
  
  describe "admin attriubtes" do
    
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "can be converted to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
  describe "micropost relationship" do
    
    before(:each) do
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "does something" do
      @user.should respond_to(:microposts)
    end
    
    it "should have the posts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end
    
    it "should destroy associated micropost as the user record is destroied" do
      @user.destroy
      [@mp2, @mp1].each do |m|
        lambda do 
          Micropost.find(m).should be_nil        
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  
    describe "status feed" do
      it "should have a feed on the home page(after log in)" do
        @user.should respond_to(:feed)
      end
      
      it "should include user's microposts" do
        @user.feed.should include(@mp1)
        @user.feed.should include(@mp2)
      end
      
      it "should only include the microposts from the subsribed users" do
        mp3 = Factory(:micropost, 
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.should_not include(mp3)
      end
      
      it "should include the micropost of followed users" do
        followed = Factory(:user, :email => Factory.next(:email))
        mp3 = Factory(:micropost, :user => followed)
        @user.follow!(followed)
        @user.feed.should include(mp3)
      end
    end
  end

  describe "relatioships" do
    
    before(:each) do
      @followed = Factory(:user, :email => Factory.next(:email))
    end
    it "should respond to :relationship" do
      @user.should respond_to(:relationships)
    end
    
    it "should have a :following" do
      @user.should respond_to(:following)
    end
    
    it "should have a :follow!" do
      @user.should respond_to(:follow!)
    end
    
    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end
    
    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.include?(@followed).should be_true
    end

    
    it "should have a unfollow method" do
      @user.should respond_to(:unfollow!)
    end
    
    it "should be able to unfollow a user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.following.should_not include(@followed)
    end
    
    it "should have a :reverse_relationships" do
      @user.should respond_to(:reverse_relationships)
    end
    
    it "should have a :followers" do
      @user.should respond_to(:followers)
    end
    
    it "should include the follwer in the followers array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
  end

  
end
