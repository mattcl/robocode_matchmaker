class AddEntriesCounterCacheToBots < ActiveRecord::Migration
  def self.up
    add_column :bots, :entries_count, :integer, :default => 0

    Bot.all.each do |bot|
      Bot.reset_counters(bot.id, :entries)
    end
  end

  def self.down
    remove_column :bots, :entries_count
  end
end
