require 'spec_helper'

describe Category do
  it { should have_and_belong_to_many(:bots) }
  it { should have_many(:matches) }
  it { should belong_to(:battle_configuration) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:battle_configuration) }

  context 'scopes' do
    describe 'by_fewest_matches' do
      it 'orders by fewest matches ASC' do
        create(:category, :matches_count => 0)
        create(:category, :matches_count => 5)
        create(:category, :matches_count => 3)
        create(:category, :matches_count => 7)
        result = Category.by_fewest_matches
        result.should have(4).categories
        result.shift.should have(0).matches
        result.shift.should have(3).matches
        result.shift.should have(5).matches
        result.shift.should have(7).matches
      end
    end
  end

  describe '.best_for_next_match' do
    it 'returns the first Category (sorted on fewest Matches) that has least one Bot' do
      category1 = create(:category, :matches_count => 0)
      category2 = create(:category, :matches_count => 5)
      category3 = create(:category, :matches_count => 3)
      category4 = create(:category, :matches_count => 7)
      create(:bot, :categories => [category2, category3, category4])
      Category.best_for_next_match.should eq(category3)
    end

    context 'when no Catgory matches the criteria' do
      it { expect(Category.best_for_next_match).to be_nil }
    end
  end

  describe '#unique_bots' do
    context 'when there are no Bots' do
      it { expect(subject.unique_bots).to be_empty }
    end

    it 'only includes the latest version of any Bot' do
      category = create(:category)
      user = create(:user)
      create(:bot, :user => user, :categories => [category], :jar_file_file_name => 'derp_1.0.jar')
      create(:bot, :user => user, :categories => [category], :jar_file_file_name => 'herp_1.0.jar')

      bot1 = create(:bot, :user => user, :categories => [category], :jar_file_file_name => 'derp_1.2.jar')
      bot2 =create(:bot, :user => user, :categories => [category], :jar_file_file_name => 'herp_1.2.jar')
      bots = category.unique_bots
      bots.to_a.should have(2).items
      bots.to_a.should include(bot1, bot2)
    end
  end
end
