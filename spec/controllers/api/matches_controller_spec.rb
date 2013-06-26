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
        create_list(:bot, 2, :categories => [category])

        Category.should_receive(:best_for_next_match).and_return(category)

        post :create, :format => :json
        response.should be_success
        body = JSON.parse(response.body)
        Match.find(body['match']).category.should eq(category)
      end

      it 'updates the attempts on the chosen Category' do
        category = create(:category, :matches_count => 3)
        create_list(:bot, 2, :categories => [category])
        Category.should_receive(:best_for_next_match).and_return(category)

        expect { post :create, :format => :json }.to change(category, :attempts).by(1)
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

    context 'without a valid id' do
      it { expect {put :update, :id => 0, :match => {}, :format => :json }.to raise_error }
    end

    context 'with invalid attributes' do
      before(:each) do
        @data = {'entries_attributes' => [{'id' => @match.entries.first.id, 'bullet_bonus' => 'derp'}]}
      end

      it 'returns success => 0' do
        put :update, :id => @match, :match => @data, :format => :json
        response.should be_success
        body = JSON.parse(response.body)
        body.should include('success')
        body['success'].should eq(0)
      end

      it 'does not update the Match' do
        put :update, :id => @match, :match => @data, :format => :json
        @match.reload
        @match.finished_at.should be_nil
      end

      it 'does not update the Entries' do
        put :update, :id => @match, :match => @data, :format => :json
        @match.reload.entries.first.bullet_bonus.should be_nil
      end
    end

    context 'with valid attributes' do
      before(:each) do
        @data = {'entries_attributes' => []}
        @match.entries.each_with_index do |entry, index|
          @data['entries_attributes'] << {
            'id' => entry.id,
            'bullet_bonus' => 10,
            'bullet_damage' => 34,
            'firsts' => 0,
            'seconds' => 1,
            'thirds' => 3,
            'ram_bonus' => 100,
            'ram_damage' => 40,
            'rank' => 2,
            'survival' => 15,
            'survival_bonus' => index + 1,
            'total_score' => 80
          }
        end
      end

      it 'returns success => 1' do
        put :update, :id => @match, :match => @data, :format => :json
        response.should be_success
        body = JSON.parse(response.body)
        body.should include('success')
        body['success'].should eq(1)
      end

      it 'updates the Match' do
        put :update, :id => @match, :match => @data, :format => :json
        @match.reload
        @match.finished_at.should_not be_nil
      end

      it 'updates the Entries' do
        put :update, :id => @match, :match => @data, :format => :json
        @match.reload.entries.each_with_index do |entry, index|
          @data['entries_attributes'][index].each do |key, value|
            entry.send(key.to_sym).should eq(value)
          end
        end
      end
    end
  end
end
