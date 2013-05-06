class BotsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @bots = Bot.includes(:categories, :user)
    @bot = current_user.bots.new if user_signed_in?
  end

  def show
    @bot = Bot.find(params[:id])
  end

  def create
    @bot = current_user.bots.new(params[:id])
    if @bot.save
      redirect_to bots_path
    else
      @bots = Bot.includes(:categories, :user)
      render :action => 'index'
    end
  end
end
