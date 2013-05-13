require 'spec_helper'

describe User do
  it { should validate_presence_of(:username) }

  describe '#matches_entered' do
    it 'is equal to the number of Matches entered' do
      create(:user).matches_entered.should eq(0)

      create(:bot).user.matches_entered.should eq(0)

      bot = create(:bot_with_entries, :entries_count => 5)
      bot.user.matches_entered.should eq(5)
    end
  end

  describe '#matches_won' do
    it 'is equal to the number of Matches won' do
      create(:user).matches_won.should eq(0)

      create(:bot).user.matches_won.should eq(0)

      bot = create(:bot_with_entries, :entries_count => 2)
      bot.user.matches_won.should eq(0)

      create(:entry_with_results, :bot => bot, :rank => 1)

      bot.reload # we previously cached the request
      bot.user.matches_won.should eq(1)
    end
  end
end
