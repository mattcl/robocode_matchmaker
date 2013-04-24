require 'spec_helper'

describe Bot do
  it { should belong_to(:user) }
  it { should have_attached_file(:jar_file) }
  it { should validate_attachment_presence(:jar_file) }
  it { should validate_attachment_content_type(:jar_file).allowing('application/x-java-archive') }
  it { should validate_attachment_size(:jar_file).less_than(2.megabytes) }

  it 'sets the base_name before saving' do
    bot = build(:bot, :base_name => 'replace', :jar_file_file_name => 'foo_bar_baz.jar')
    bot.base_name.should eq('replace')
    bot.save!
    bot.reload.base_name.should eq('foo_bar')
  end
end
