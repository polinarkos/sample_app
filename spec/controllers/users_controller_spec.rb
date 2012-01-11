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
                                            :href => user_path(@user))
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


  describe "POST 'create'" do
    
    describe 'failure' do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", 
                  :password_confirmation => "" }
      end

      it "should have the right title" do
        post 'create', :user => @attr
        response.should have_selector('title', :content => "Sign up")
      end
      
      it "should render the new page" do
        post 'create', :user => @attr
        response.should render_template('new')
      end        

      it "should not create a user" do
        lambda do
          post 'create', :user => @attr
        end.should_not change(User, :count)
      end
    end

  describe "success" do
    before(:each) do
       @attr = { :name => "Valid User", :email => "pom@lala.com", 
            :password => "drolmetkak", :password_confirmation => "drolmetkak" }
    end    

    it "should create a user" do
        lambda do
          post 'create', :user => @attr
        end.should change(User, :count).by(1)
    end
    it "shoudl redirect to user show page" do
      post 'create', :user => @attr
      response.should redirect_to(user_path(assigns(:user)))
    end
    it "should have a flash message" do
      post :create, :user => @attr
      flash[:success].should =~ /welcome to the sample app/i
    end
    
    it "should sign the user in after signing up" do
      post :create, :user => @attr
      controller.should be_signed_in
    end

  end


  end

end
