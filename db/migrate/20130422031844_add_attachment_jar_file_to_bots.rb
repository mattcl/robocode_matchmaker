class AddAttachmentJarFileToBots < ActiveRecord::Migration
  def self.up
    change_table :bots do |t|
      t.attachment :jar_file
    end
  end

  def self.down
    drop_attached_file :bots, :jar_file
  end
end
