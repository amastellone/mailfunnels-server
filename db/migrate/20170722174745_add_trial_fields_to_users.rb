class AddTrialFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :trial, :integer
  end
end
