class AddFieldsToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :username, :string
    add_column :apps, :password, :string
  end
end
