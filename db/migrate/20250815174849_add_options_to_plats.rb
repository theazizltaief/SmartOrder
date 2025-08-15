class AddOptionsToPlats < ActiveRecord::Migration[8.0]
  def change
    add_column :plats, :sauces,      :text, array: true, default: [], null: false
    add_column :plats, :legumes,     :text, array: true, default: [], null: false
    add_column :plats, :supplements, :text, array: true, default: [], null: false
  end
end
