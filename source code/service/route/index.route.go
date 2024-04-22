package route

import (
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/handler"
	"github.com/khensin166/PA2-Kel9/middleware"
)

func RouteInit(r *fiber.App) {
	r.Post("/login", handler.LoginHandler)
	r.Get("/user", middleware.Auth, handler.UserHandlerGetAll)
	r.Get("/user/:id", handler.UserHandlerGetById)
	r.Post("/user", handler.UserHandlerCreate)
	r.Put("/user/:id", handler.UserHandlerUpdate)
}
