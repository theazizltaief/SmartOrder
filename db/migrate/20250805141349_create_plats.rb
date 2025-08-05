class CreatePlats < ActiveRecord::Migration[8.0]
  def change
    create_table :plats do |t|
      t.string :nom
      t.text :description
      t.integer :prix_en_centimes
      t.string :type_de_plat

      t.timestamps
    end
  end
end
