require 'spec_helper'

describe Bot do
  it { should have_attached_file(:jar_file) }
  it { should validate_attachment_presence(:jar_file) }
  it { should validate_attachment_content_type(:jar_file).allowing('application/x-java-archive') }
  it { should validate_attachment_size(:jar_file).less_than(2.megabytes) }
end
