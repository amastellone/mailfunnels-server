class AddFieldsToFunnels < ActiveRecord::Migration[5.0]
  def change
    add_column :funnels, :active, :integer
  end
end
