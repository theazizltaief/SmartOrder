import consumer from "./consumer"

consumer.subscriptions.create("OrdersChannel", {
  connected() {
    console.log("✅ [Browser] Connecté à OrdersChannel")
  },
  
  disconnected() {
    console.log("⚠️ [Browser] Déconnecté de OrdersChannel")
  },
  
  received(data) {
    console.log("📩 [Browser] Commande reçue :", data)
  }
})