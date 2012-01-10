require 'spec_helper'

describe UsersController do
render_views

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successfull" do
      get :show, :id => @user  # it knows it's @user.id
      response.should be_success
    end
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user 
      #goes up into the controller to instance var @user 
    end
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", 
                                    :content => @user.name)
    end
    it "should have the right h1" do
      get :show, :id => @user
      response.should have_selector('h1', :content => @user.name)
    end

    it "it should have a gravatar" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => "gravatar")      
    end

    it "should have the right url" do
      get :show, :id => @user
      response.should have_selector('dd>a', :content => user_path(@user),
                                            :hraf => user_path(@user))
    end

  end
    


  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", 
                                    :content => "Sign up")
    end
  end

end
