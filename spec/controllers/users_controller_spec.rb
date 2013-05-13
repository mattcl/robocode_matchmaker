require 'spec_helper'

describe UsersController do
  before(:each) do
    @users = create_list(:user, 2)
  end

  describe 'GET index' do
    it 'assigns all Users to @users' do
      get 'index'

      response.should be_success
      assigns(:users).should eq(@users)
    end
  end

  describe 'GET show' do
    it 'assigns the specified User to @user' do
      get 'show', :id => @users.first

      response.should be_success
      assigns(:user).should eq(@users.first)
    end
  end
end
