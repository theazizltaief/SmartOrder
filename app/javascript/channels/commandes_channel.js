import consumer from "./consumer"

consumer.subscriptions.create("CommandesChannel", {
  connected() {
    console.log("✅ Connecté à CommandesChannel (Rails côté navigateur)")
  },
  disconnected() {
    console.log("❌ Déconnecté de CommandesChannel")
  },
  received(data) {
    console.log("📩 Donnée reçue :", data)
  }
})
