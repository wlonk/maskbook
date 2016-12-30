class AddAttachmentMugshotToVillains < ActiveRecord::Migration
  def self.up
    change_table :villains do |t|
      t.attachment :mugshot
    end
  end

  def self.down
    remove_attachment :villains, :mugshot
  end
end
