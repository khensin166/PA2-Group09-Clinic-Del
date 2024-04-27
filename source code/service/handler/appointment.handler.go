package handler

import (
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"log"
)

func AppointmentGetAll(c *fiber.Ctx) error {
	var appointment []entity.Appointment

	database.DB.Preload("User").Find(&appointment)

	return c.JSON(fiber.Map{
		"appointment": appointment,
	})
}

func CreateAppointment(c *fiber.Ctx) error {
	appointment := new(entity.AppointmentResponse)

	//PARSE TO OBJECT STRUCT
	if err := c.BodyParser(appointment); err != nil {
		return c.Status(503).JSON(fiber.Map{
			"err": err,
		})
	}

	// VALIDATION
	log.Println(appointment.RequestedID)
	if appointment.RequestedID == 0 {
		return c.Status(400).JSON(fiber.Map{
			"err": "requested_id is required",
		})
	}

	if err := database.DB.Create(&appointment).Error; err != nil {
		// Mengembalikan respon error 500 dengan pesan yang sesuai
		return c.Status(500).JSON(fiber.Map{
			"message": "failed to store data",
			"error":   err.Error(), // Menambahkan pesan error ke respon JSON
		})
	}

	return c.JSON(fiber.Map{
		"message":     "create data successfully",
		"appointment": appointment,
	})
}
