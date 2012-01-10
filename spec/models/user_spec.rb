require 'spec_helper'

describe User do

  before(:each) do 
    @attr = {:name => "Testyser",
             :email => "user@example.com",
             :password => "foobar",
             :password_confirmation => "foobar" }
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it "shoudl require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end


  it "shoudl reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[foo@bar.org bar@lst.la.com baz.list@kak.jp]
    addresses.each do |a|
      valid_email_user = User.new(@attr.merge(:email => a))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[foo@bar,org bar_at_lst.la.com baz.list@kak.]
    addresses.each do |a|
      invalid_email_user = User.new(@attr.merge(:email => a))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_dup_email = User.new(@attr)
    user_with_dup_email.should_not be_valid
  end

  it "shoudl reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_dup_email = User.new(@attr)
    user_with_dup_email.should_not be_valid
  end
  

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)   
    end   
    
    it "shoudl have a password attribute" do
      @user.should respond_to(:password)
    
    end


    it "should have a password doncifmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
      
  end

  
  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", 
            :password_confirmation => "")).should_not be_valid
    end

    it "shoudl require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should should reject short passes" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should should reject long passes" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end


  describe "password encrption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted attr" do
      @user.should respond_to(:encrypted_password)
    end


    it "should set the encrupted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

    it "should have a salt" do
      @user.should respond_to(:salt)
    end

    describe "has_password? method" do
      it "should exist" do  
        @user.should respond_to(:has_password?)
      end
      it "should return true if the passes match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should return false otherwise" do
        @user.has_password?("invalkd").should be_false
      end
    end

    describe "authenticate method" do
      it "should exist" do
        User.should respond_to(:authenticate)
      end
      it "shoudl return nil on email pasword mismatch" do 
        User.authenticate(@attr[:email], "wrongpass").should be_nil
      end
      it "should reutnr nil for an emai lwith no user" do
        User.authenticate("kakaka@lol.fout", @attr[:password]).should be_nil
      end
      it"shoudl return the user on email/pass match" do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

