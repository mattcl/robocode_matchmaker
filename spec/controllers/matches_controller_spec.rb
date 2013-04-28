require 'spec_helper'

describe MatchesController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "POST create" do
    it 'creates a new match given a category' do
      pending 'writing the creation logic'
      category = create(:category)
      Match.should_receive(:new).with("category_id" => category.id)
      post :create, { "category_id" => category.id }
    end

    it 'saves the match'

    it 'redirects to the Matches index' do
      post :create
      response.should redirect_to(:action => "index")
    end
  end
end
