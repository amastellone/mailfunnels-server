class AddFieldsToCapturedHooks < ActiveRecord::Migration[5.0]
  def change
    add_column :captured_hooks, :revenue, :decimal
    add_column :captured_hooks, :type, :integer
  end
end
