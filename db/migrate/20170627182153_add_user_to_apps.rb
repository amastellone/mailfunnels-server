class AddUserToApps < ActiveRecord::Migration[5.0]
  def change
    add_reference :apps, :user, foreign_key: true
  end
end
