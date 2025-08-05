class ChangeDefaultStatutInCommandes < ActiveRecord::Migration[8.0]
  def change
    change_column_default :commandes, :statut, from: nil, to: "en_attente"
  end
end
