require 'spec_helper'

describe Entry do
  it { should belong_to(:bot) }
  it { should belong_to(:match) }

  it 'specifies a counter cache on Bot' do
    bot = create(:bot)
    bot.entries_count.should eq(0)

    create(:entry, :bot => bot)
    bot.reload.entries_count.should eq(1)
  end
end
