require 'spec_helper'

describe BattleConfiguration do
  it { should have_many(:categories) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:num_bots) }
  it { should validate_presence_of(:width) }
  it { should validate_presence_of(:height) }
  it { should validate_presence_of(:num_rounds) }
  it { should validate_numericality_of(:num_bots).only_integer }
  it { should validate_numericality_of(:width).only_integer }
  it { should validate_numericality_of(:height).only_integer }
  it { should validate_numericality_of(:num_rounds).only_integer }
end
