class CreateLigneCommandes < ActiveRecord::Migration[8.0]
  def change
    create_table :ligne_commandes do |t|
      t.references :commande, null: false, foreign_key: true
      t.references :plat, null: false, foreign_key: true
      t.integer :quantite
      t.string :remarque

      t.timestamps
    end
  end
end
