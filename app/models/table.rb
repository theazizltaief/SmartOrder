class Table < ApplicationRecord
  # Association avec les commandes
  has_many :commandes, dependent: :destroy

  # Validations
  validates :numero, presence: true, uniqueness: true

  # Méthode pour afficher le nom de la table
  def nom_complet
    "Table #{numero}"
  end
end
