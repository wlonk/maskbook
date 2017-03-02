class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :villain, foreign_key: true

      t.timestamps
    end

    add_index :favorites, [:user_id, :villain_id], unique: true
  end
end
