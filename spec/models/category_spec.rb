require 'spec_helper'

describe Category do
  it { should have_and_belong_to_many(:bots) }
  it { should have_many(:matches) }
  it { should belong_to(:battle_configuration) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:battle_configuration) }
end
