require 'spec_helper'

describe MatchesController do

  describe 'GET index' do
    before(:each) do
      @matches = create_list(:match, 2)
    end

    it 'populates an array of Matches, with the latest Matches first' do
      get 'index'
      response.should be_success
      assigns(:matches).should eq(@matches.reverse)
    end
  end

  describe 'GET show' do
    before(:each) do
      @match = create(:match)
    end

    it 'assigns the requested match to @match' do
      get :show, :id => @match
      assigns(:match).should eq(@match)
    end

    it 'renders the show view' do
      get :show, :id => @match
      response.should render_template :show
    end
  end
end
