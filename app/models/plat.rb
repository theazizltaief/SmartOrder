class Plat < ApplicationRecord
  has_one_attached :photo
  has_many :ligne_commandes
end
