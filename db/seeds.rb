exit 0 if Rails.env == 'test'

# create our default configurations
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

# create our default skill levels
beginner = SkillLevel.create({:name => 'Beginner'})
intermediate = SkillLevel.create({:name => 'Intermediate'})
advanced = SkillLevel.create({:name => 'Advanced'})

# create our default categories
one_v_one = Category.create({:name => '1v1', :battle_configuration  => config_one_on_one, :skill_level => beginner})
mele      = Category.create({:name => 'Mele', :battle_configuration => config_mele, :skill_level       => beginner})

i_one_v_one = Category.create({:name => '1v1', :battle_configuration  => config_one_on_one, :skill_level => intermediate})
i_mele      = Category.create({:name => 'Mele', :battle_configuration => config_mele, :skill_level       => intermediate})

a_one_v_one = Category.create({:name => '1v1', :battle_configuration => config_one_on_one, :skill_level => advanced})
a_mele      = Category.create({:name => 'Mele', :battle_configuration => config_mele, :skill_level => advanced})

exit 0 if Rails.env == 'production'

# create default htf user
htf_user = User.create(:username => 'htf', :email => 'htf@htf.com', :password => 'test1234', :password_confirmation => 'test1234')

# rampancy
rampancy = User.create(:username => 'rampancy', :email => 'mchunlum@gmail.com', :password => 'test1234', :password_confirmation => 'test1234')

# create the bots for the htf user
crazy = htf_user.bots.create({
  :jar_file => File.new("#{Rails.root}/db/seed_bots/htf.Crazy_1.0.jar"),
  :category_ids => [one_v_one.id, mele.id]
})

tracker = htf_user.bots.create({
  :jar_file => File.new("#{Rails.root}/db/seed_bots/htf.Tracker_1.0.jar"),
  :category_ids => [one_v_one.id, mele.id]
})

spinbot = htf_user.bots.create({
    :jar_file => File.new("#{Rails.root}/db/seed_bots/htf.SpinBot_1.0.jar"),
    :category_ids => [one_v_one.id, mele.id]
})

corners = htf_user.bots.create({
    :jar_file => File.new("#{Rails.root}/db/seed_bots/htf.Corners_1.0.jar"),
    :category_ids => [one_v_one.id, mele.id]
})

ramfire = htf_user.bots.create({
  :jar_file => File.new("#{Rails.root}/db/seed_bots/htf.RamFire_1.0.jar"),
  :category_ids => [one_v_one.id, mele.id]
})

# intermediate bots
walls = htf_user.bots.create({
  :jar_file => File.new("#{Rails.root}/db/seed_bots/htf.Walls_1.0.jar"),
  :category_ids => [i_one_v_one.id, i_mele.id]
})

# advanced bots
rampancy.bots.create({
  :jar_file => File.new("#{Rails.root}/db/seed_bots/rampancy.micro.Swingline_1.0.jar"),
  :category_ids => [a_one_v_one.id]
})

rampancy.bots.create({
  :jar_file => File.new("#{Rails.root}/db/seed_bots/rampancy.micro.Epiphron_1.0.jar"),
  :category_ids => [a_one_v_one.id]
})

rampancy.bots.create({
  :jar_file => File.new("#{Rails.root}/db/seed_bots/rampancy.WhuphsCT_1.0.jar"),
  :category_ids => [a_one_v_one.id, a_mele.id]
})

rampancy.bots.create({
  :jar_file => File.new("#{Rails.root}/db/seed_bots/rampancy.tycho.Tycho_1.0.jar"),
  :category_ids => [a_one_v_one.id]
})

rampancy.bots.create({
  :jar_file => File.new("#{Rails.root}/db/seed_bots/rampancy.Durandal_2.2d.jar"),
  :category_ids => [a_one_v_one.id]
})

# create a htf match
match = Match.create({
  :category => mele,
  :started_at => 5.minutes.ago,
  :finished_at => Time.now
})

# create some htf Entries
entries = Entry.create([
  {
    :bot_id         => spinbot.id,
    :match_id       => match.id,
    :rank           => 1,
    :total_score    => 1577,
    :survival       => 800,
    :survival_bonus => 0,
    :bullet_damage  => 661,
    :bullet_bonus   => 86,
    :ram_damage     => 31,
    :ram_bonus      => 0,
    :firsts         => 4,
    :seconds        => 0,
    :thirds         => 0
  },
  {
    :bot_id         => tracker.id,
    :match_id       => match.id,
    :rank           => 2,
    :total_score    => 1084,
    :survival       => 450,
    :survival_bonus => 0,
    :bullet_damage  => 548,
    :bullet_bonus   => 64,
    :ram_damage     => 23,
    :ram_bonus      => 0,
    :firsts         => 0,
    :seconds        => 1,
    :thirds         => 2
  },
  {
    :bot_id         => ramfire.id,
    :match_id       => match.id,
    :rank           => 3,
    :total_score    => 1060,
    :survival       => 250,
    :survival_bonus => 0,
    :bullet_damage  => 543,
    :bullet_bonus   => 0,
    :ram_damage     => 187,
    :ram_bonus      => 80,
    :firsts         => 0,
    :seconds        => 0,
    :thirds         => 2
  },
  {
    :bot_id         => crazy.id,
    :match_id       => match.id,
    :rank           => 4,
    :total_score    => 951,
    :survival       => 750,
    :survival_bonus => 0,
    :bullet_damage  => 176,
    :bullet_bonus   => 5,
    :ram_damage     => 20,
    :ram_bonus      => 0,
    :firsts         => 1,
    :seconds        => 3,
    :thirds         => 1
  },
  {
    :bot_id         => corners.id,
    :match_id       => match.id,
    :rank           => 5,
    :total_score    => 842,
    :survival       => 250,
    :survival_bonus => 0,
    :bullet_damage  => 536,
    :bullet_bonus   => 52,
    :ram_damage     => 4,
    :ram_bonus      => 0,
    :firsts         => 0,
    :seconds        => 1,
    :thirds         => 0
  }
])
