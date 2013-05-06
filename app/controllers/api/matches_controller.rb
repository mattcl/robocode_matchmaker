class Api::MatchesController < ApplicationController
  respond_to :json

  def create
    pending_matches = Match.pending
    if pending_matches.any?
      @match = pending_matches.first
    else
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
    if @match and params[:match]
      params[:match]['finished_at'] = Time.now
      if @match.update_attributes(params[:match])
        render :json => {:success => 1}
        return
      end
    end

    render :json => {:success => 0}
  end
end
