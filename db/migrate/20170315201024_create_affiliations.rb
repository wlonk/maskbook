class CreateAffiliations < ActiveRecord::Migration[5.0]
  def change
    create_table :affiliations do |t|
      t.references :villain, foreign_key: true
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
