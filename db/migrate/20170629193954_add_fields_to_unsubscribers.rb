class AddFieldsToUnsubscribers < ActiveRecord::Migration[5.0]
  def change
    add_column :unsubscribers, :initial_ref_type, :integer
  end
end
