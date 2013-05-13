class UsersController < ApplicationController
  def index
    @users = User.includes(:bots).all
  end

  def show
    @user = User.includes(:bots).find(params[:id])
  end
end
