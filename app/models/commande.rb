class Commande < ApplicationRecord
  belongs_to :table
  has_many :ligne_commandes, dependent: :destroy

  accepts_nested_attributes_for :ligne_commandes
end
