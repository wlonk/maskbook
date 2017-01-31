class AddCollaboratorsToVillains < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :villains do |t|
      t.index [:user_id, :villain_id]
      t.index [:villain_id, :user_id]
    end
  end
end
