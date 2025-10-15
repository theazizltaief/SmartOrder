import { application } from "./application"
import panier_controller from "./panier_controller"
import tags_controller from "./tags_controller"

application.register("panier", panier_controller)
application.register("tags", tags_controller)

console.log("✅ Controllers chargés")