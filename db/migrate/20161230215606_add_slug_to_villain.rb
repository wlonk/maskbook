class AddSlugToVillain < ActiveRecord::Migration[5.0]
  def change
    add_column :villains, :slug, :string
    add_index :villains, :slug, unique: true
  end
end
