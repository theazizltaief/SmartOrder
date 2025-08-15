import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["liste", "json", "total", "count"]

  connect() {
    console.log("🛒 Panier controller connecté sur:", this.element)

    // Initialiser le panier global une seule fois
    if (!window.smartOrderPanier) {
      window.smartOrderPanier = []
    }

    // Éviter les reconnexions multiples
    if (this.element.dataset.panierConnected) {
      return
    }
    this.element.dataset.panierConnected = "true"

    this.updatePanier()
  }

  disconnect() {
    this.element.dataset.panierConnected = ""
  }

  ajouter(event) {
    event.preventDefault()

    const button = event.currentTarget
    const platId = button.dataset.platId
    const platPrixCentimes = Number.parseInt(button.dataset.platPrix) || 0
    const card = button.closest(".card")

    if (!card) {
      console.error("Card non trouvée")
      return
    }

    const platNom = card.querySelector("h3")?.textContent?.trim() || "Plat inconnu"
    const remarqueField = card.querySelector("textarea")
    const remarque = remarqueField?.value?.trim() || ""
    // Récupérer les options sélectionnées
    const sauces = Array.from(card.querySelectorAll('input[name="sauces[]"]:checked')).map(i => i.value);
    const legumes = Array.from(card.querySelectorAll('input[name="legumes[]"]:checked')).map(i => i.value);
    const supplements = Array.from(card.querySelectorAll('input[name="supplements[]"]:checked')).map(i => i.value);

    console.log("Ajout:", { platId, platNom, platPrixCentimes, remarque })

    // Chercher si l'article existe déjà
    const existingIndex = window.smartOrderPanier.findIndex((item) => item.plat_id === platId)

    if (existingIndex >= 0) {
      // Augmenter la quantité
      window.smartOrderPanier[existingIndex].quantite += 1
      window.smartOrderPanier[existingIndex].sauces = sauces;
      window.smartOrderPanier[existingIndex].legumes = legumes;
      window.smartOrderPanier[existingIndex].supplements = supplements;
      if (remarque) {
        window.smartOrderPanier[existingIndex].remarque = remarque
      }
    } else {
      // Ajouter nouvel article
      window.smartOrderPanier.push({
        plat_id: platId,
        quantite: 1,
        remarque: remarque,
        nom: platNom,
        prix_centimes: platPrixCentimes,
        sauces: sauces,
        legumes: legumes,
        supplements: supplements
      })
    }

    console.log("Panier après ajout:", window.smartOrderPanier)

    // Mettre à jour TOUS les paniers sur la page
    this.updateAllPaniers()

    // Animation du bouton
    this.animateButton(button)

    // Vider le champ remarque
    if (remarqueField) {
      remarqueField.value = ""
    }

    // Toast simple
    this.showToast(`${platNom} ajouté au panier`)
  }

  supprimer(event) {
    const platId = event.currentTarget.dataset.platId
    const item = window.smartOrderPanier.find((item) => item.plat_id === platId)
    const platNom = item ? item.nom : "Article"

    window.smartOrderPanier = window.smartOrderPanier.filter((item) => item.plat_id !== platId)
    this.updateAllPaniers()
    this.showToast(`${platNom} supprimé`)
  }

  modifierQuantite(event) {
    const platId = event.currentTarget.dataset.platId
    const action = event.currentTarget.dataset.actionParam
    const item = window.smartOrderPanier.find((item) => item.plat_id === platId)

    if (item) {
      if (action === "increase") {
        item.quantite += 1
      } else if (action === "decrease") {
        item.quantite -= 1
        if (item.quantite <= 0) {
          window.smartOrderPanier = window.smartOrderPanier.filter((i) => i.plat_id !== platId)
        }
      }
      this.updateAllPaniers()
    }
  }

  updateAllPaniers() {
    // Mettre à jour tous les contrôleurs panier sur la page
    document.querySelectorAll('[data-controller*="panier"]').forEach((element) => {
      const controller = this.application.getControllerForElementAndIdentifier(element, "panier")
      if (controller && controller !== this) {
        controller.updatePanier()
      }
    })
    this.updatePanier()
  }

  updatePanier() {
    console.log("Mise à jour panier:", window.smartOrderPanier)

    // Mettre à jour le compteur
    if (this.hasCountTarget) {
      this.countTarget.textContent = window.smartOrderPanier.length
    }

    // Mettre à jour le total
    const total = this.calculateTotal()
    if (this.hasTotalTarget) {
      this.totalTarget.textContent = this.formatPriceDT(total)
    }

    // Mettre à jour la liste
    if (this.hasListeTarget) {
      if (window.smartOrderPanier.length === 0) {
        this.listeTarget.innerHTML = `
          <div style="text-align: center; padding: 2rem; color: #7f8c8d;">
            <p>🛒 Votre panier est vide</p>
            <p style="font-size: 0.9rem;">Ajoutez des articles pour commencer</p>
          </div>
        `
      } else {
        this.listeTarget.innerHTML = window.smartOrderPanier
          .map(
            (item) => `
          <div class="panier-item" style="background: #f8f9fa; padding: 1rem; border-radius: 10px; margin-bottom: 1rem;">
            <div style="font-weight: 600; margin-bottom: 0.5rem;">${item.nom}</div>
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div style="display: flex; align-items: center; gap: 0.5rem;">
                <button type="button" class="btn btn-sm btn-secondary" 
                        data-action="click->panier#modifierQuantite" 
                        data-plat-id="${item.plat_id}" 
                        data-action-param="decrease">-</button>
                <span style="font-weight: 600;">${item.quantite}</span>
                <button type="button" class="btn btn-sm btn-secondary" 
                        data-action="click->panier#modifierQuantite" 
                        data-plat-id="${item.plat_id}" 
                        data-action-param="increase">+</button>
              </div>
              <div style="font-weight: 600;">${this.formatPriceDT(item.prix_centimes * item.quantite)}</div>
            </div>
            ${item.remarque ? `<div style="font-style: italic; color: #6c757d; margin-top: 0.5rem;">"${item.remarque}"</div>` : ""}
            <button type="button" class="btn btn-danger btn-sm" style="margin-top: 0.5rem;" 
                    data-action="click->panier#supprimer" 
                    data-plat-id="${item.plat_id}">🗑️ Supprimer</button>
          </div>
        `,
          )
          .join("")
      }
    }

    // Mettre à jour le JSON pour l'envoi
    if (this.hasJsonTarget) {
      const cleanData = window.smartOrderPanier.map((item) => ({
        plat_id: item.plat_id,
        quantite: item.quantite,
        remarque: item.remarque || "",
        sauces: item.sauces || [],
        legumes: item.legumes || [],
        supplements: item.supplements || []
      }))
      this.jsonTarget.value = JSON.stringify(cleanData)
      console.log("JSON pour envoi:", this.jsonTarget.value)
    }
  }

  calculateTotal() {
    return window.smartOrderPanier.reduce((total, item) => {
      return total + (item.prix_centimes || 0) * (item.quantite || 0)
    }, 0)
  }

  // Formater le prix en dinars tunisiens
  formatPriceDT(centimes) {
    if (!centimes || centimes === 0) return "0.000 DT"

    const dinars = centimes / 1000.0
    return `${dinars.toFixed(3)} DT`
  }

  animateButton(button) {
    const originalText = button.textContent
    const originalBg = button.style.background

    button.textContent = "✅ Ajouté !"
    button.style.background = "#28a745"
    button.disabled = true

    setTimeout(() => {
      button.textContent = originalText
      button.style.background = originalBg
      button.disabled = false
    }, 1500)
  }

  showToast(message) {
    const toast = document.createElement("div")
    toast.textContent = message
    toast.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      background: #28a745;
      color: white;
      padding: 1rem;
      border-radius: 5px;
      z-index: 9999;
      animation: slideIn 0.3s ease-out;
    `

    document.body.appendChild(toast)

    setTimeout(() => {
      toast.style.animation = "slideOut 0.3s ease-in"
      setTimeout(() => {
        if (document.body.contains(toast)) {
          document.body.removeChild(toast)
        }
      }, 300)
    }, 3000)
  }

  submit(event) {
    if (window.smartOrderPanier.length === 0) {
      event.preventDefault()
      this.showToast("Votre panier est vide !")
      return
    }

    const total = this.calculateTotal()
    const confirmed = confirm(
      `Confirmer la commande de ${window.smartOrderPanier.length} article(s) pour ${this.formatPriceDT(total)} ?`,
    )

    if (!confirmed) {
      event.preventDefault()
      return
    }

    // Mettre à jour le JSON une dernière fois
    this.updatePanier()

    console.log("Envoi de la commande:", this.jsonTarget.value)

    // Vider le panier après envoi réussi
    setTimeout(() => {
      window.smartOrderPanier = []
      this.updateAllPaniers()
    }, 1000)
  }
}
