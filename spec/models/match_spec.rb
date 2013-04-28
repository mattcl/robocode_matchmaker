require 'spec_helper'

describe Match do
  it { should belong_to(:category) }
  it { should have_many(:entries) }
  it { should have_many(:bots).through(:entries) }
  it { should validate_presence_of(:category) }

  describe '.create_for' do
    it 'creates a new Match for the given Category' do
      category = create(:category)
      match = Math.create_for(category)
    end
  end
end
