class LigneCommande < ApplicationRecord
  belongs_to :commande
  belongs_to :plat

  # PostgreSQL arrays - pas besoin de serialize
  # Les champs sauces, legumes, supplements sont déjà des arrays en DB

  # Méthodes pour convertir entre strings (formulaire) et arrays (DB)
  def sauces_text
    sauces&.join(", ") || ""
  end

  def sauces_text=(value)
    self.sauces = value.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def legumes_text
    legumes&.join(", ") || ""
  end

  def legumes_text=(value)
    self.legumes = value.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def supplements_text
    supplements&.join(", ") || ""
  end

  def supplements_text=(value)
    self.supplements = value.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  # Valeurs par défaut pour éviter les nil
  after_initialize :set_defaults

  private

  def set_defaults
    self.sauces ||= []
    self.legumes ||= []
    self.supplements ||= []
  end
end
