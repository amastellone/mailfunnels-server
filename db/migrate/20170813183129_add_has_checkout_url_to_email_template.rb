class AddHasCheckoutUrlToEmailTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :email_templates, :has_checkout_url, :integer
  end
end
