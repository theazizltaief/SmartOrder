class LigneCommande < ApplicationRecord
  belongs_to :commande
  belongs_to :plat
  # Optionnel : validations si tu veux forcer présence
  # validates :sauces, :legumes, :supplements, presence: true
end
