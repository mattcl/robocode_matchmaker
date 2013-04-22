require 'spec_helper'

describe "bots/edit" do
  before(:each) do
    @bot = assign(:bot, stub_model(Bot,
      :user_id => 1
    ))
  end

  it "renders the edit bot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bot_path(@bot), "post" do
      assert_select "input#bot_user_id[name=?]", "bot[user_id]"
    end
  end
end
