class AddGenerationToVillain < ActiveRecord::Migration[5.0]
  def change
    add_column :villains, :generation, :integer, default: 0
  end
end
