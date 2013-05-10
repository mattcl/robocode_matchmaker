class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def show
    @match = Match.includes(:category, :entries, :bots).find(params[:id])
  end
end
