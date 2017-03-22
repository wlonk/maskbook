class AddUserToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_reference :organizations, :user, foreign_key: true
  end
end
