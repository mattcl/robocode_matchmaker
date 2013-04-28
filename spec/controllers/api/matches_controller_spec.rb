require 'spec_helper'

describe Api::MatchesController do
  render_views

  describe 'Post create' do
    # this sort of seems like the wrong place for this test.
    # maybe see if it's possible to have a view spec for jbuilder
    it 'responds with the required information for the Runner to start a Match' do
        create(:bot) # sanity check
        match = create(:match, :bots => create_list(:bot, 3))
        post :create, :format => :json
        response.should be_success
        body = JSON.parse(response.body)
        body.should include('success', 'match', 'configuration', 'entries')
        body['success'].should eq(1)
        body['match'].should eq(match.id)

        expected_config = match.category.battle_configuration
        config = body['configuration']
        config.should include('width', 'height', 'num_bots', 'num_rounds')
        config['width'].should eq(expected_config.width)
        config['height'].should eq(expected_config.height)
        config['num_bots'].should eq(expected_config.num_bots)
        config['num_rounds'].should eq(expected_config.num_rounds)

        expected_entries = match.entries.collect { |entry| {'id' => entry.id, 'proper_name' => entry.bot.proper_name} }
        entries = body['entries']
        entries.should have(3).items
        entries.should eq(expected_entries)
    end

    context 'when there are pending Matches' do
      it 'responds with the oldest pending Match' do
        match1 = create(:match, :bots => create_list(:bot, 3))
        match2 = create(:match, :bots => create_list(:bot, 2))
        post :create, :format => :json
        response.should be_success
        body = JSON.parse(response.body)
        body['match'].should eq(match1.id)
      end
    end

    context 'when there are no pending Matches' do
      it 'creates a new Match from the Category determined by Category.best_for_next_match' do
        category = create(:category, :matches_count => 3)
        create(:bot, :categories => [category])

        Category.should_receive(:best_for_next_match).and_return(category)

        post :create, :format => :json
        response.should be_success
        body = JSON.parse(response.body)
        Match.find(body['match']).category.should eq(category)
      end

      context 'when no Categories with Bots exist' do
        it 'responds with a no-op' do
          post :create, :format => :json

          response.should be_success
          body = JSON.parse(response.body)
          body.should include('success')
          body['success'].should eq(0)
        end
      end
    end

    it 'sets the started_at time for the chosen Match' do
      match1 = create(:match, :bots => create_list(:bot, 3))
      match1.started_at.should be_nil
      post :create, :format => :json
      match1.reload.started_at.should_not be_nil
    end
  end

  describe 'PUT update' do
    before(:each) do
      @category = create(:category)
      @bots = create_list(:bot, 3, :categories => [@category])
      @match = create(:match, :category => @category, :bots => @bots)
    end

    context 'with valid attributes' do
      it 'updates the Match' do
        data = Jbuilder.encode do |json|
          json.entries @match.entries, :id, :rank, :ram_bonus, :ram_damage, :bullet_bonus, :bullet_damage, :survival, :survival_bonus, :total_score, :firsts, :seconds, :thirds
        end
        put :update, :id => @match, :data => JSON.parse(data), :format => :json
      end
    end
  end
end
