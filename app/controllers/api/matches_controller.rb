class Api::MatchesController < ApplicationController
  respond_to :json

  def create
    pending_matches = Match.pending
    if pending_matches.any?
      @match = pending_matches.first
    else
      # TODO: fix this
      category = Category.best_for_next_match
      @match = Match.create_for(category) unless category.nil?
    end

    if @match.nil?
      render :json => {:success => 0}
    else
      @match.started_at = Time.now
      @match.save!
      @match
    end
  end

  def update
    @match = Match.find(params[:id])
    require 'pp'
    pp params
    if @match

    end

    render :json => {:success => 0}
  end
end
