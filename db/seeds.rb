config_one_on_one = BattleConfiguration.create({
  :description => 'A 1v1 battle',
  :num_bots => 2,
  :num_rounds => 5,
  :width => 800,
  :height => 600
})

config_mele = BattleConfiguration.create({
  :description => 'A 5 bot brawl',
  :num_bots => 5,
  :num_rounds => 5,
  :width => 800,
  :height => 600
})

one_v_one = Category.create({:name => '1v1', :battle_configuration => config_one_on_one})
mele = Category.create({:name => 'Mele', :battle_configuration => config_mele})

sample_user = User.create(:username => 'sample', :password => 'test1234', :password_confirmation => 'test1234')

sample_user.bots.create([
  {
    :jar_file => File.new("#{Rails.root}/db/seed_bots/sample.Crazy_1.0.jar")
    :category_ids => [one_v_one, mele]
  },
  {
    :jar_file => File.new("#{Rails.root}/db/seed_bots/sample.Tracker.0.jar")
    :category_ids => [one_v_one, mele]
  },
  {
    :jar_file => File.new("#{Rails.root}/db/seed_bots/sample.SpinBot_1.0.jar")
    :category_ids => [one_v_one, mele]
  },
  {
    :jar_file => File.new("#{Rails.root}/db/seed_bots/sample.Corners_1.0.jar")
    :category_ids => [one_v_one, mele]
  },
  {
    :jar_file => File.new("#{Rails.root}/db/seed_bots/htf.ExampleBot_1.0.jar")
    :category_ids => [one_v_one, mele]
  }
])

case Rails.env
when 'development' do

end
