class AddRemarqueGeneraleToCommandes < ActiveRecord::Migration[8.0]
  def change
    add_column :commandes, :remarque_generale, :text
  end
end
