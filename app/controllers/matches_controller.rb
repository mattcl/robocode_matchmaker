class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def show
    @match = Match.includes(:category, :bots).find(params[:id])
  end
end
