import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
static targets = ["liste", "form", "json", "remarque"]

connect() {
  this.commande = []
  this.majPanier()
}

ajouter(event) {
  const platId = event.currentTarget.dataset.platId
  const carte = event.currentTarget.closest(".card")
  const remarque = carte.querySelector("textarea").value || ""
  const existant = this.commande.find(item => item.plat_id == platId)

  if (existant) {
    existant.quantite += 1
  } else {
    this.commande.push({ plat_id: platId, quantite: 1, remarque: remarque })
  }

  this.majPanier()

  event.currentTarget.innerText = "✔️ Ajouté !"
  setTimeout(() => event.currentTarget.innerText = "Ajouter au panier", 1000)
}

majPanier() {
  if (this.hasListeTarget) {
    this.listeTarget.innerHTML = ""
    this.commande.forEach(item => {
      const li = document.createElement("li")
      li.innerHTML = `Plat ${item.plat_id} × ${item.quantite}<br><em>${item.remarque}</em>`
      this.listeTarget.appendChild(li)
    })
  }

  if (this.hasJsonTarget) {
    this.jsonTarget.value = JSON.stringify(this.commande)
    console.log("Contenu du panier JSON envoyé :", this.jsonTarget.value)
  }
}

submit(event) {
  if (this.commande.length === 0) {
    event.preventDefault()
    alert("Votre panier est vide !")
  } else {
    this.majPanier() // s'assure que le champ JSON est rempli juste avant l'envoi
  }
}

}
