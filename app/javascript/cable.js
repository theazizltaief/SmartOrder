import { createConsumer } from "@rails/actioncable"

// On crée la connexion WebSocket
const cable = createConsumer("ws://localhost:3000/cable")

export default cable
