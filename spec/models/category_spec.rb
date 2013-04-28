require 'spec_helper'

describe Category do
  it { should have_and_belong_to_many(:bots) }
  it { should have_many(:matches) }
  it { should belong_to(:battle_configuration) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:battle_configuration) }

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
