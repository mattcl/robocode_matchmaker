FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "derpmaster_#{n}" }
    sequence(:email) { |n| "derp#{n}@derpmaster.com" }
    password 'test1234'
    password_confirmation { 'test1234' }
  end

  factory :category do
    sequence(:name) { |n| "category-#{n}" }
    association :battle_configuration
  end

  factory :bot do
    user
    sequence(:jar_file_file_name) { |n| "derp#{n}_bot_1.2.jar" }
    jar_file_content_type { 'application/x-java-archive' }
    jar_file_file_size { 1024 }
    base_name ''
    categories { |a| [a.association(:category)] }

    factory :bot_with_entries do
      ignore do
        entries_count 5
      end

      after(:create) do |bot, evaluator|
        FactoryGirl.create_list(:match, evaluator.entries_count, :bots => [bot])
      end
    end

    factory :invalid_bot do
      jar_file_file_name nil
    end
  end

  factory :match do
    association :category
  end

  factory :entry do
    association :bot
    association :match
    bullet_bonus 100
    bullet_damage 10
    firsts 1
    seconds 2
    thirds 1
    ram_bonus 15
    ram_damage 4
    rank 4
    survival 3
    survival_bonus 10
    total_score 200
  end
end
