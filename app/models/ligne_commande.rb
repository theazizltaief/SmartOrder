class LigneCommande < ApplicationRecord
  belongs_to :commande
  belongs_to :plat
end
