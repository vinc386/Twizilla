require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      :name => "foobar", 
      :email => "foobar@twizilla.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
    @user = User.create!(@attr) #for password part
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
    
    it "should return nil for no email/no user" do
      User.authenticate('not_exist@email.com', @attr[:password]).should be_nil
    end
    
    it "should return a user on match" do
      User.authenticate(@attr[:email], @attr[:password]).should == @user
    end
  end
end
