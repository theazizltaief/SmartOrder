class AddOptionsToLigneCommandes < ActiveRecord::Migration[8.0]
  def change
    add_column :ligne_commandes, :sauces,      :text, array: true, default: [], null: false
    add_column :ligne_commandes, :legumes,     :text, array: true, default: [], null: false
    add_column :ligne_commandes, :supplements, :text, array: true, default: [], null: false
  end
end
