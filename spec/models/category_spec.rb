require 'spec_helper'

describe Category do
  it { should have_and_belong_to_many(:bots) }
  it { should have_many(:matches) }
  it { should belong_to(:battle_configuration) }
  it { should belong_to(:skill_level) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:battle_configuration) }

  context 'scopes' do
    describe 'by_fewest_attempts' do
      it 'orders by fewest attempts ASC' do
        create(:category, :attempts => 0)
        create(:category, :attempts => 5)
        create(:category, :attempts => 3)
        create(:category, :attempts => 7)
        result = Category.by_fewest_attempts
        result.should have(4).categories
        result.shift.attempts.should eq(0)
        result.shift.attempts.should eq(3)
        result.shift.attempts.should eq(5)
        result.shift.attempts.should eq(7)
      end
    end

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
    it 'returns the Category with the fewest attempts' do
      category2 = create(:category, :attempts => 5)
      category4 = create(:category, :attempts => 7)
      category1 = create(:category, :attempts => 0)
      category3 = create(:category, :attempts => 3)
      Category.best_for_next_match.should eq(category1)
    end

    context 'when no Catgory matches the criteria' do
      it { expect(Category.best_for_next_match).to be_nil }
    end
  end

  describe '#detail_name' do
    it 'includes the Skill Level' do
      skill_level = create(:skill_level)
      category = create(:category, :skill_level => skill_level)
      expected = "#{skill_level.name} #{category.name}"
      category.detail_name.should eq(expected)
    end
  end

  describe '#note_attempt' do
    it 'increments the number of attempts by 1' do
      category = create(:category)
      expect { category.note_attempt }.to change(category, :attempts).by(1)
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
