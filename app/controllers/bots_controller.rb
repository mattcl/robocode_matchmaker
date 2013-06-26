class BotsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @bots = Bot.includes(:categories, :user)
    @grouped_bots = {}
    @skill_levels = SkillLevel.includes(:categories)
    @skill_levels.each do |level|
      categories = level.categories
      @grouped_bots[level.name] = @bots.reject { |b| (b.categories & categories).empty? }
    end
    if user_signed_in?
      @bot = current_user.bots.new
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
