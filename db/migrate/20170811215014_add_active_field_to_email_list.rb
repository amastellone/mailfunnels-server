class AddActiveFieldToEmailList < ActiveRecord::Migration[5.0]
  def change
    add_column :email_lists, :active, :integer
  end
end
