package handler

import (
	"errors"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"gorm.io/gorm"
	"log"
)

func ClinicInformationGetByID(ctx *fiber.Ctx) error {
	clinicInformationId := ctx.Params("id")
	var clinicInformation entity.ClinicInformation

	// Query statement with GORM, including preloading related fields
	err := database.DB.Preload("Gallery").First(&clinicInformation, "id = ?", clinicInformationId).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return ctx.Status(404).JSON(fiber.Map{
				"message": "clinic information not found",
			})
		}
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal Server Error",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    clinicInformation,
	})
}

func ClinicInformationGetAll(ctx *fiber.Ctx) error {
	var clinicInformations []entity.ClinicInformation
	err := database.DB.Preload("Gallery").Find(&clinicInformations).Error
	if err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal Server Error",
		})
	}
	return ctx.Status(200).JSON(fiber.Map{
		"clinic_information": clinicInformations,
	})
}

func ClinicInformationReport(ctx *fiber.Ctx) error {
	clinicInformation := &entity.ClinicInformation{}

	if err := ctx.BodyParser(clinicInformation); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "Bad Request",
			"error":   err.Error(),
		})
	}

	if err := database.DB.Create(clinicInformation).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Failed to store data",
			"error":   err.Error(),
		})
	}

	response := entity.ClinicInformationResponse{
		ID:          clinicInformation.ID,
		GalleryID:   clinicInformation.GalleryID,
		Gallery:     clinicInformation.Gallery,
		Description: clinicInformation.Description,
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message":            "create data successfully",
		"clinic_information": response,
	})
}

func UpdateClinicInformation(ctx *fiber.Ctx) error {
	clinicInformation := new(entity.ClinicInformation)

	if err := ctx.BodyParser(clinicInformation); err != nil {
		return ctx.Status(400).JSON(fiber.Map{"message": "Bad Request"})
	}

	log.Printf("Clinic Information Request: %+v", clinicInformation) // Log data received

	var existingClinicInformation entity.ClinicInformation

	clinicInformationID := ctx.Params("id")

	// CHECK AVAILABLE CLINIC INFORMATION
	err := database.DB.First(&existingClinicInformation, "id = ?", clinicInformationID).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return ctx.Status(404).JSON(fiber.Map{
				"message": "Clinic Information not found",
			})
		}
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal Server Error",
		})
	}

	// Update existing clinic information with new values
	if clinicInformation.GalleryID != 0 {
		existingClinicInformation.GalleryID = clinicInformation.GalleryID
	}

	log.Printf("Updated Clinic Information: %+v", existingClinicInformation) // Log data before saving

	errUpdate := database.DB.Save(&existingClinicInformation).Error
	if errUpdate != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal Server Error",
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "success updating data",
		"data":    existingClinicInformation,
	})
}

func DeleteClinicInformation(ctx *fiber.Ctx) error {
	clinicInformationID := ctx.Params("id")

	// Start a transaction
	tx := database.DB.Begin()

	// Delete related gallery first
	if err := tx.Where("id = ?", clinicInformationID).Delete(&entity.Gallery{}).Error; err != nil {
		tx.Rollback()
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Failed to delete related gallery",
		})
	}

	// Delete the clinic information
	if err := tx.Delete(&entity.ClinicInformation{}, "id = ?", clinicInformationID).Error; err != nil {
		tx.Rollback()
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Failed to delete clinic information",
		})
	}

	// Commit the transaction
	if err := tx.Commit().Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Failed to commit transaction",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "clinic information deleted successfully",
	})
}

func GetUserDataForClinicInformation(ctx *fiber.Ctx) error {
	var approvedAppointments []entity.Appointment

	// Fetch all approved appointments
	if err := database.DB.Where("approved_id IS NOT NULL").Find(&approvedAppointments).Error; err != nil {
		log.Println("Error fetching approved appointments:", err)
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Error fetching approved appointments",
		})
	}

	var updatedNurseReports []entity.NurseReport

	// Process approved appointments and update nurse reports
	for _, appointment := range approvedAppointments {
		var nurseReport entity.NurseReport

		// Check if nurse report already exists
		err := database.DB.Preload("Patient").Preload("StaffNurse").Where("patient_id = ? AND staff_nurse_id = ?", appointment.RequestedID, appointment.ApprovedID).First(&nurseReport).Error
		if err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				// If not found, create a new nurse report
				nurseReport = entity.NurseReport{
					PatientID:    appointment.RequestedID,
					StaffNurseID: *appointment.ApprovedID,
				}

				// Save the new nurse report
				if err := database.DB.Create(&nurseReport).Error; err != nil {
					log.Println("Error creating nurse report:", err)
					return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
						"message": "Error creating nurse reports",
					})
				}
			} else {
				log.Println("Error fetching nurse report:", err)
				continue // Skip if other errors occur
			}
		} else {
			// Update nurse report with necessary data
			nurseReport.PatientID = appointment.RequestedID
			nurseReport.StaffNurseID = *appointment.ApprovedID

			// Save the updated nurse report
			if err := database.DB.Save(&nurseReport).Error; err != nil {
				log.Println("Error updating nurse report:", err)
				return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"message": "Error updating nurse reports",
				})
			}
		}

		updatedNurseReports = append(updatedNurseReports, nurseReport)
	}

	return ctx.Status(fiber.StatusOK).JSON(fiber.Map{
		"message":       "Successfully updated nurse reports",
		"nurse_reports": updatedNurseReports,
	})
}
