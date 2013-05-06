require 'spec_helper'

describe MatchesController do

  describe 'GET index' do
    before(:each) do
      @matches = create_list(:match, 2)
    end

    it 'populates an array of Matches' do
      get 'index'
      response.should be_success
      assigns(:matches).should eq(@matches)
    end
  end
end
