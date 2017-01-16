class AddPublicToVillains < ActiveRecord::Migration[5.0]
  def change
    add_column :villains, :public, :boolean, default: true
  end
end
