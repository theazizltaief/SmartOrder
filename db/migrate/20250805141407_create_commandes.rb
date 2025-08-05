class CreateCommandes < ActiveRecord::Migration[8.0]
  def change
    create_table :commandes do |t|
      t.references :table, null: false, foreign_key: true
      t.string :statut

      t.timestamps
    end
  end
end
