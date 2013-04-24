class UpdateExistingBotsWithBasename < ActiveRecord::Migration
  def up
    Bot.all.each { |bot| bot.save! }
  end
end
