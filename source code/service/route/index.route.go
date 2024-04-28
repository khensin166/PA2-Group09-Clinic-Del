package route

import (
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/handler"
	"github.com/khensin166/PA2-Kel9/middleware"
)

func RouteInit(r *fiber.App) {
	// AUTHENTICATION
	r.Post("/login", handler.LoginHandler)
	r.Post("/staffLogin", handler.StaffLoginHandler)

	// USER
	r.Get("/users", middleware.Auth, handler.UserHandlerGetAll)
	r.Get("/user/:id", handler.UserHandlerGetById)
	r.Post("/user", handler.UserHandlerCreate)
	r.Put("/user/:id", handler.UserHandlerUpdate)

	// APPOINTMENT
	r.Get("/appointment", handler.AppointmentGetAll)
	r.Post("/appointment", handler.CreateAppointment)

	// STAFF
	r.Get("/staffs", middleware.Auth, handler.StaffHandlerGetAll)
	r.Get("/staff/:id", handler.StaffHandlerGetById)
	r.Post("/staff", handler.StaffHandlerCreate)
	r.Put("/staff/:id", handler.StaffHandlerUpdate)
}
