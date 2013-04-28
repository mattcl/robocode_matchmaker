json.success 1
json.match @match.id

json.configuration do
  config = @match.category.battle_configuration
  json.width config.width
  json.height config.height
  json.num_bots config.num_bots
  json.num_rounds config.num_rounds
end

json.entries @match.entries do |entry|
  json.id entry.id
  json.proper_name entry.bot.proper_name
end
