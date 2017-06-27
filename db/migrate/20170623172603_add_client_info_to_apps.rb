class AddClientInfoToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :clientid, :integer
    add_column :apps, :client_tag, :string
  end
end
