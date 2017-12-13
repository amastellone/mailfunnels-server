class CreateTemplateHyperlinks < ActiveRecord::Migration[5.0]
  def change
    create_table :template_hyperlinks do |t|

      t.timestamps
    end
  end
end
