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

  context 'scopes' do
    before(:each) do
      @started = create(:entry)
      @finished = create(:entry_with_results)
    end

    describe 'finished' do
      it 'returns only Entries with rank == nil' do
        entries = Entry.finished
        entries.should have(1).entries
        entries.should include(@finished)
      end
    end
  end

  context 'on update' do
    before(:each) do
      @entry = create(:entry_with_results)
    end

    [:bullet_bonus, :bullet_damage, :firsts, :ram_bonus, :ram_damage,
      :rank, :seconds, :survival, :survival_bonus, :thirds, :total_score].each do |sym|
      it "validates #{sym.to_s} is integer" do
        @entry.update_attributes({sym => 'foo'}).should be_false
        @entry.update_attributes({sym => 1.2}).should be_false
        @entry.update_attributes({sym => 1}).should be_true
      end
    end
  end
end
