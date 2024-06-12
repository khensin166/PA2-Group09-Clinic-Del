package handler

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"github.com/khensin166/PA2-Kel9/utils"
	"gorm.io/gorm"
	"log"
	"time"
)

func AppointmentGetByAuth(ctx *fiber.Ctx) error {
	// Mendapatkan token dari header Authorization
	token := ctx.Get("Authorization")
	if token == "" {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated",
		})
	}

	// Mendekode token untuk mendapatkan informasi pengguna
	claims, err := utils.DecodeToken(token)
	if err != nil {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated err",
		})
	}

	// Mendapatkan ID pengguna dari token
	userID := int(claims["id"].(float64))

	// Melakukan query ke basis data untuk mendapatkan appointment yang sesuai dengan ID pengguna
	// Anda perlu menyesuaikan sesuai dengan struktur tabel dan kueri yang benar
	var appointments []entity.Appointment
	err = database.DB.Where("requested_id = ?", userID).Find(&appointments).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "appointment not found",
		})
	}

	// Membuat slice baru untuk menyimpan data appointment yang akan dikirim ke client
	var responseAppointments []interface{}
	for _, appointment := range appointments {
		responseAppointment := map[string]interface{}{
			"id":        appointment.ID,
			"date":      appointment.Date,
			"time":      appointment.Time,
			"complaint": appointment.Complaint,
			"approved":  appointment.ApprovedID,
		}
		responseAppointments = append(responseAppointments, responseAppointment)
	}

	// Mengembalikan data appointment dalam format JSON
	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    responseAppointments,
	})
}

func AppointmentGetByiD(ctx *fiber.Ctx) error {
	// mencari user parameter id.
	appointmentId := ctx.Params("id")

	// mendeklarasikan variabel user dengan tipe data userEntity
	var appointment entity.Appointment

	// Query Statement dengan GORM
	err := database.DB.Preload("Approved").Preload("Requested").First(&appointment, "id = ?", appointmentId).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "user not found",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    appointment,
	})
}

func AppointmentGetAll(ctx *fiber.Ctx) error {
	var appointments []entity.Appointment

	// Memuat entitas terkait menggunakan Preload
	result := database.DB.Preload("Approved").Preload("Requested").Find(&appointments)
	if result.Error != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to fetch appointments",
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"success":      "get data success",
		"appointments": appointments,
	})
}

func AppointmentGetAllApproved(ctx *fiber.Ctx) error {
	var appointments []entity.Appointment

	/// Memuat entitas terkait menggunakan Preload
	result := database.DB.Preload("Approved").Preload("Requested").Find(&appointments)
	if result.Error != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to fetch appointments",
		})
	}

	// Mengumpulkan hanya janji yang memiliki approved_id tidak nil
	var approvedAppointments []entity.Appointment
	for _, appointment := range appointments {
		if appointment.ApprovedID != nil {
			approvedAppointments = append(approvedAppointments, appointment)
		}
	}

	return ctx.Status(200).JSON(fiber.Map{
		"success":      "get data success",
		"appointments": approvedAppointments,
	})
}

func CreateAppointment(ctx *fiber.Ctx) error {
	appointment := new(entity.Appointment)

	// PARSE TO OBJECT STRUCT
	if err := ctx.BodyParser(appointment); err != nil {
		return ctx.Status(503).JSON(fiber.Map{
			"err": err,
		})
	}

	// Check for the latest appointment (regardless of requested_id)
	var lastAppointment entity.Appointment
	if err := database.DB.Order("date desc").First(&lastAppointment).Error; err != nil {
		if err != gorm.ErrRecordNotFound {
			return ctx.Status(500).JSON(fiber.Map{
				"message": "Gagal mendapatkan janji temu terakhir",
				"error":   err.Error(),
			})
		}
	}

	// Parse last appointment date to time.Time if it exists
	if lastAppointment.ID != 0 {
		const customTimeFormat = "2006-01-02T15:04:05.000"
		lastAppointmentTime, err := time.Parse(customTimeFormat, lastAppointment.Date)
		if err != nil {
			return ctx.Status(500).JSON(fiber.Map{
				"message": "Format tanggal janji temu terakhir tidak valid",
				"error":   err.Error(),
			})
		}

		// Parse the appointment date input by user
		appointmentTime, err := time.Parse(customTimeFormat, appointment.Date)
		if err != nil {
			return ctx.Status(400).JSON(fiber.Map{
				"message": "Format tanggal janji temu tidak valid",
				"error":   err.Error(),
			})
		}

		// For debugging purposes
		fmt.Printf("Last appointment time: %s\n", lastAppointmentTime)
		fmt.Printf("New appointment time: %s\n", appointmentTime)

		// Check the time difference
		timeDifference := appointmentTime.Sub(lastAppointmentTime)
		if timeDifference < 30*time.Minute {
			nextAvailableTime := lastAppointmentTime.Add(30 * time.Minute)
			return ctx.Status(400).JSON(fiber.Map{
				"message": fmt.Sprintf("Anda hanya dapat membuat janji temu 30 menit setelah janji temu terakhir. Janji temu terakhir adalah pada %s. Anda dapat membuat janji temu baru setelah %s.",
					lastAppointmentTime.Format("15:04:05"), nextAvailableTime.Format("15:04:05")),
			})
		}
	}

	// Create new appointment
	if err := database.DB.Create(&appointment).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Gagal menyimpan data",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message":     "Berhasil membuat janji temu",
		"appointment": appointment,
	})
}

func UpdateApprovedID(ctx *fiber.Ctx) error {
	// Get the ID from the URL
	id := ctx.Params("id")

	// Find the appointment in the database
	appointment := new(entity.AppointmentResponse)
	if err := database.DB.First(&appointment, id).Error; err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "appointment not found",
			"error":   err.Error(),
		})
	}

	// Parse the updated data
	updatedAppointment := new(entity.AppointmentResponse)
	if err := ctx.BodyParser(updatedAppointment); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "error parsing data",
			"error":   err.Error(),
		})
	}

	// Validate the parsed data
	if updatedAppointment.ApprovedID == nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "approved_id is required",
		})
	}

	// Update the appointment in the database
	appointment.ApprovedID = updatedAppointment.ApprovedID

	if err := database.DB.Save(&appointment).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "failed to update data",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message":     "update data successfully",
		"appointment": appointment,
	})
}

func UpdateAppointment(ctx *fiber.Ctx) error {
	appointmentRequest := new(entity.AppointmentUpdate)
	if err := ctx.BodyParser(appointmentRequest); err != nil {
		return ctx.Status(400).JSON(fiber.Map{"message": "Bad request"})
	}

	var appointment entity.Appointment

	appointmentID := ctx.Params("id")
	// CHECK AVAILABLE APPOINTMENT
	err := database.DB.First(&appointment, "id = ?", appointmentID).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "Appointment not found",
		})
	}

	// UPDATE APPOINTMENT DATA
	if appointmentRequest.Date != "" {
		appointment.Date = appointmentRequest.Date
	}
	if appointmentRequest.Time != "" {
		appointment.Time = appointmentRequest.Time
	}
	if appointmentRequest.Complaint != "" {
		appointment.Complaint = appointmentRequest.Complaint
	}

	errUpdate := database.DB.Model(&appointment).Updates(entity.Appointment{
		Date:      appointment.Date,
		Time:      appointment.Time,
		Complaint: appointment.Complaint,
	}).Error

	if errUpdate != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal server error",
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "success",
		"data":    appointment,
	})
}

func DeleteAppointment(c *fiber.Ctx) error {
	id := c.Params("id")

	var appointment entity.Appointment
	if err := database.DB.First(&appointment, id).Error; err != nil {
		log.Println(err)
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Appointment not found",
		})
	}

	if err := database.DB.Delete(&appointment).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to delete user",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Appointment deleted successfully",
	})
}
