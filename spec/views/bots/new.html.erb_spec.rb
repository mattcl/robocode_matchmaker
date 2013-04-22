require 'spec_helper'

describe "bots/new" do
  before(:each) do
    assign(:bot, stub_model(Bot,
      :user_id => 1
    ).as_new_record)
  end

  it "renders new bot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bots_path, "post" do
      assert_select "input#bot_user_id[name=?]", "bot[user_id]"
    end
  end
end
