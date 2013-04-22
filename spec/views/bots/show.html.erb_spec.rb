require 'spec_helper'

describe "bots/show" do
  before(:each) do
    @bot = assign(:bot, stub_model(Bot,
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
