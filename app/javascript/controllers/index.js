// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application"

import panier_controller from "./panier_controller"
application.register("panier_controller", panier_controller)
