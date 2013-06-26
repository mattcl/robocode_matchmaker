class BotsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @bots = Bot.includes(:categories, :user)
    if user_signed_in?
      @bot = current_user.bots.new
      @skill_levels = SkillLevel.all
    end
  end

  def show
    @bot = Bot.includes(:entries).find(params[:id])
  end

  def create
    @bot = current_user.bots.new(params[:bot])
    if @bot.save
      redirect_to bots_path
    else
      @bots = Bot.includes(:categories, :user)
      render :action => 'index'
    end
  end
end
