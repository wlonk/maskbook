class CreateConditionsVillains < ActiveRecord::Migration[5.0]
  def change
    remove_column :villains, :conditions

    create_table :conditions_villains, id: false do |t|
      t.belongs_to :condition, index: true
      t.belongs_to :villain, index: true
    end
  end
end
