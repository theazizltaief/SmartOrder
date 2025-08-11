class Commande < ApplicationRecord
  # Association avec la table
  belongs_to :table

  # Association avec les lignes de commande
  has_many :ligne_commandes, dependent: :destroy
  accepts_nested_attributes_for :ligne_commandes

  # Validation du statut
  validates :statut, inclusion: { in: %w[en_attente en_preparation prete servie annulee] }

  # Validation de la présence de table_id
  validates :table_id, presence: true
end
