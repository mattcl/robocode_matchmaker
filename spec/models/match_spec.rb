require 'spec_helper'

describe Match do
  it { should belong_to(:category) }
  it { should have_many(:entries) }
  it { should have_many(:bots).through(:entries) }
  it { should accept_nested_attributes_for(:entries) }
  it { should validate_presence_of(:category) }

  context 'scopes' do
    before(:each) do
      @pending_match = create(:match)
      @running_match = create(:match, :started_at => Time.now)
      @finished_match = create(:match, :started_at => Time.now, :finished_at => 2.hours.from_now)
    end

    describe 'pending' do
      it 'returns only matches with started_at == nil' do
        matches = Match.pending
        matches.should have(1).matches
        matches.should include(@pending_match)
      end
    end

    describe 'running' do
      it 'returns only matches with started_at != nil and finished_at == nil' do
        matches = Match.running
        matches.should have(1).matches
        matches.should include(@running_match)
      end
    end

    describe 'finished' do
      it 'returns only matches with finished_at != nil' do
        matches = Match.finished
        matches.should have(1).matches
        matches.should include(@finished_match)
      end
    end
  end

  describe '.create_for' do
    let(:category) { create(:category) }

    it 'uses category#unique_bots' do
      category.should_receive(:unique_bots).and_return([])
      Match.create_for(category)
    end

    context 'when there are Bots' do
      before(:each) do
        create(:bot, :categories => [category])
      end

      it 'creates a new Match for the given Category' do
        match = Match.create_for(category)
        match.should be_a(Match)
        match.should have(1).entries
      end

      it 'only creates Entries from Bots of the specified Category' do
        create(:bot) # a bot in a different category
        match = Match.create_for(category)
        match.should have(1).entries
      end
    end

    context 'when there are no Bots' do
      it { expect(Match.create_for(category)).to be_nil }
    end

    context 'when there are fewer Bots for the Category than we need' do
      it 'creates as many Entries as possible' do
        create(:bot, :categories => [category])
        match = Match.create_for(category)
        match.should have(1).entries

        create(:bot, :categories => [category])
        match = Match.create_for(category)
        match.should have(2).entries
      end
    end

    context 'when there are more Bots for the Catageory than we need' do
      it 'creates only as many Entries as specified by the Category' do
        max_bots = category.battle_configuration.num_bots
        create_list(:bot, max_bots + 2, :categories => [category])
        match = Match.create_for(category)
        match.should have(max_bots).entries
      end

      it 'selects Bots with the fewest previous Entries first' do
        config = create(:battle_configuration, :num_bots => 2)
        category = create(:category, :battle_configuration => config)

        # by creating bots in this way we can ensure that the list would need to
        # be sorted in order to return the desired result

        create(:bot_with_entries, :categories => [category], :entries_count => 3)
        bot1 = create(:bot_with_entries, :categories => [category], :entries_count => 1)
        create(:bot_with_entries, :categories => [category], :entries_count => 4)
        bot2 = create(:bot, :categories => [category])

        match = Match.create_for(category)
        match.should have(2).entries
        match.bots.should include(bot1, bot2)
      end
    end
  end

  describe '#status' do
    context 'for a match that has not started' do
      it 'is "pending"' do
        build(:match).status.should eq('pending')
      end
    end

    context 'for a match that has started but not finished' do
      it 'is "running"' do
        build(:started_match).status.should eq('running')
      end
    end

    context 'for a match that has finished' do
      it 'is "finished"' do
        build(:finished_match).status.should eq('finished')
      end
    end
  end

  describe '#winner' do
    context 'when the match is finished' do
      it 'returns the Bot corresponding to the Entry with rank 1' do
        match = create(:finished_match)
        expected = match.entries.where(:rank => 1).first
        match.winner.should eq(expected)
      end
    end

    context 'when the match is not finished' do
      it 'returns nil' do
        match = create(:started_match)
        match.winner.should be_nil
      end
    end

    context 'when the match is not started' do
      it 'returns nil' do
        match = create(:match_with_bots)
        match.winner.should be_nil
      end
    end
  end
end
