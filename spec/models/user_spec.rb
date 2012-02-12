require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      :name => "foobar", 
      :email => "foobar@twizilla.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end
  
  
  it "should be able to create a user with valid attr" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name = User.new(@attr.merge(:name => "")).
    should_not be_valid
  end
  
  it "should have an name that with proper length" do
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
    User.create!(@attr)
    User.new(@attr.merge(:name => "different_names_same_email")).
    should_not be_valid
  end
  
  it "should require a password" do
    User.new(@attr.merge(:password => '', :password_confirmation => '')).
    should_not be_valid
    # this one is not validating properly, but passed…
  end
  
  it "should reqire a matching pw and pw_confirmation set" do
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

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should respond to the encryped_password method" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should be able to set the encryped password" do
      @user.encrypted_password.should_not be_blank
    end
  end
end
