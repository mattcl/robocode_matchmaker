require 'spec_helper'

describe Bot do
  it { should belong_to(:user) }
  it { should have_many(:entries) }
  it { should have_many(:matches).through(:entries) }
  it { should have_attached_file(:jar_file) }
  it { should validate_attachment_presence(:jar_file) }
  it { should validate_attachment_content_type(:jar_file).allowing('application/x-java-archive') }
  it { should validate_attachment_size(:jar_file).less_than(2.megabytes) }

  describe '#base_name' do
    it 'is set before validation' do
      bot = build(:bot, :base_name => 'replace', :jar_file_file_name => 'foo_bar_baz.jar')
      bot.base_name.should eq('replace')
      bot.should be_valid # trigger the validation callbacks
      bot.base_name.should eq('foo_bar')
    end

    it 'is not valid if base_name is owned by a different User' do
      create(:bot, :jar_file_file_name => 'derp.bot_1.0.jar').should be_valid

      invalid_bot = build(:bot, :jar_file_file_name => 'derp.bot_1.0.jar')
      invalid_bot.should_not be_valid
      invalid_bot.errors[:jar_file].should include('the package and name combination has already been taken by another user')
    end

    it 'is valid if base_name is owned by same User' do
      user = create(:user)
      create(:bot, :user => user, :jar_file_file_name => 'derp.bot_1.0.jar').should be_valid
      create(:bot, :user => user, :jar_file_file_name => 'derp.bot_1.2.jar').should be_valid
    end
  end
end
