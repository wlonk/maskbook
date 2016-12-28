class CreateVillains < ActiveRecord::Migration[5.0]
  def change
    create_table :villains do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.text :drive
      t.text :moves
      t.text :conditions
      t.text :abilities
      t.text :description

      t.timestamps
    end
    add_index :villains, [:user_id, :created_at]
  end
end
