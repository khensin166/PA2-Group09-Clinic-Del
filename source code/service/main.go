package main

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/database/migration"
	"github.com/khensin166/PA2-Kel9/route"
)

func main() {

	// INITIAL DATABASE
	database.DatabaseInit()

	// RUN MIGRATION
	migration.Migration()

	// menginisialisasikan go fiber (di passing ke route)
	app := fiber.New()

	app.Use(cors.New())
	// INITIAL ROUTE
	route.RouteInit(app)

	err := app.Listen(":8080")
	if err != nil {
		return
	}
}
