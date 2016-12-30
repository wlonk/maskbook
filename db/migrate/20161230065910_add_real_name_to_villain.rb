class AddRealNameToVillain < ActiveRecord::Migration[5.0]
  def change
    add_column :villains, :real_name, :string
  end
end
