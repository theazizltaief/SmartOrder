class MenuController < ApplicationController
  def index
    @plats = Plat.where(type_de_plat: "Plat")
    @boissons = Plat.where(type_de_plat: "Boisson")
    @commande = Commande.new
  end
end
