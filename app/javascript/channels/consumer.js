import { createConsumer } from "@rails/actioncable"

// Ici, l’URL du WS Rails
const consumer = createConsumer("ws://localhost:3000/cable")

export default consumer
