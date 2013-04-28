require 'spec_helper'

describe Entry do
  it { should belong_to(:bot) }
  it { should belong_to(:match) }
end
