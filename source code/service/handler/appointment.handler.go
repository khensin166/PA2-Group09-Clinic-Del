package handler

import (
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
)

func AppointmentGetAll(c *fiber.Ctx) error {
	var appointment []entity.Appointment

	database.DB.Preload("User").Find(&appointment)

	return c.JSON(fiber.Map{
		"appointment": appointment,
	})
}

func CreateAppointment(c *fiber.Ctx) error {
	appointment := new(entity.Appointment)

	//PARSE TO OBJECT STRUCT
	if err := c.BodyParser(appointment); err != nil {
		return c.Status(503).JSON(fiber.Map{
			"err": err,
		})
	}

	// VALIDATION
	if appointment.RequestedID == 0 {
		return c.Status(400).JSON(fiber.Map{
			"err": "user_id is required",
		})

	}

	database.DB.Create(&appointment)

	return c.JSON(fiber.Map{
		"message":     "create data successfully",
		"appointment": appointment,
	})
}
