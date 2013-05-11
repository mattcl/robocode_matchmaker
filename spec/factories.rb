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

    ignore do
      categories_count 2
    end

    categories { FactoryGirl.create_list(:category, categories_count) }

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

  factory :new_bot, :class => Bot do
    user
    jar_file Rack::Test::UploadedFile.new('spec/fixtures/jar_files/rampancy.micro.Epiphron_1.0.jar', 'application/x-java-archive')
  end

  factory :match do
    association :category

    factory :match_with_bots do
      ignore do
        bots_count 3
        finished false
      end

      factory :started_match do
        started_at { 2.minutes.ago }

        factory :finished_match do

          finished_at { Time.now }

          ignore do
            finished true #change the behavior of the entry creation
          end
        end
      end

      after(:create) do |match, evaluator|
        bots = create_list(:bot, evaluator.bots_count, :categories => [evaluator.category])
        bots.each_with_index do |bot, index|
          if evaluator.finished
            create(:entry_with_results, :bot => bot, :match => match, :rank => index + 1)
          else
            create(:entry, :bot => bot, :match => match)
          end
        end
      end
    end
  end

  factory :entry do
    association :bot
    association :match

    factory :entry_with_results do
      sequence(:bullet_bonus) { |n| n * 5 + 100 }
      sequence(:bullet_damage) { |n| n * 4 + 10 }
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
end
