class MatchesController < ApplicationController
  def index
    @matches = Match.order('id DESC')
  end

  def show
    @match = Match.includes(:category, :entries, :bots).find(params[:id])
  end
end
