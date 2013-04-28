# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :battle_configuration do
    description "derp battle"
    num_bots 5
    width 800
    height 600
    num_rounds 5
  end
end
