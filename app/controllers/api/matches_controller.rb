class Api::MatchesController < ApplicationController
  respond_to :json

  def create
    pending_matches = Matches.pending
    if pending_matches.any?
      @match = pending_matches.last
    else
      # TODO: fix this
      @match = Match.create_for(Category.first)
    end
  end
end
