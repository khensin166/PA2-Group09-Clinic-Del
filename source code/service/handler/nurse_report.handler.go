package handler

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"github.com/khensin166/PA2-Kel9/utils"
	"gorm.io/gorm"
	"log"
)

func NurseReportGetByiD(ctx *fiber.Ctx) error {
	nurseReportId := ctx.Params("id")
	var nurseReport entity.NurseReport

	// Query statement with GORM, including preloading related fields
	err := database.DB.Preload("Patient").Preload("StaffNurse").First(&nurseReport, "id = ?", nurseReportId).Error
	if err != nil {
		if err.Error() == "record not found" {
			return ctx.Status(404).JSON(fiber.Map{
				"message": "Nurse report not found",
			})
		}
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal Server Error",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    nurseReport,
	})
}

func NurseReportGetAll(ctx *fiber.Ctx) error {
	var nurseReports []entity.NurseReportResponse
	err := database.DB.Preload("Patient").Preload("StaffNurse").Find(&nurseReports).Error
	if err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal Server Error",
		})
	}
	return ctx.Status(200).JSON(fiber.Map{
		"nurse_reports": nurseReports,
	})
}

func CreateNurseReport(ctx *fiber.Ctx) error {
	nurseReport := &entity.NurseReport{}

	if err := ctx.BodyParser(nurseReport); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "Bad Request",
			"error":   err.Error(),
		})
	}

	// VALIDATION Request
	validate := validator.New()
	if err := validate.Struct(nurseReport); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "Validation failed",
			"error":   err.Error(),
		})
	}

	// VALIDATION TOKEN
	token := ctx.Get("Authorization")
	if token == "" {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated",
		})
	}

	claims, err := utils.DecodeToken(token)
	if err != nil {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated",
		})
	}

	role := claims["role"].(float64)
	if role == 2 {
		return ctx.Status(fiber.StatusForbidden).JSON(fiber.Map{
			"message": "Doctor can't create the data",
		})
	}

	if err := database.DB.Create(nurseReport).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Failed to store data",
			"error":   err.Error(),
		})
	}

	response := entity.NurseReportResponse{
		ID:                nurseReport.ID,
		Temperature:       nurseReport.Temperature,
		Systole:           nurseReport.Systole,
		Diastole:          nurseReport.Diastole,
		Pulse:             nurseReport.Pulse,
		Respiration:       nurseReport.Respiration,
		SizeCircumference: nurseReport.SizeCircumference,
		Allergy:           nurseReport.Allergy,
		StaffNurseID:      int(nurseReport.StaffNurseID),
		PatientID:         int(nurseReport.PatientID),
	}
	return ctx.Status(200).JSON(fiber.Map{
		"message":      "create data successfully",
		"nurse_report": response,
	})
}

func UpdateNurseReport(ctx *fiber.Ctx) error {
	reportRequest := new(entity.NurseReportResponseUpdate)

	if err := ctx.BodyParser(reportRequest); err != nil {
		return ctx.Status(400).JSON(fiber.Map{"message": "Bad Request"})
	}

	log.Printf("Report Request: %+v", reportRequest) // Log data received

	var report entity.NurseReport

	reportID := ctx.Params("id")

	// CHECK AVAILABLE NURSE REPORT
	err := database.DB.First(&report, "id = ?", reportID).Error
	if err != nil {
		if err.Error() == "record not found" {
			return ctx.Status(404).JSON(fiber.Map{
				"message": "NurseReport not found",
			})
		}
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal Server Error",
		})
	}

	// UPDATE REPORT DATA
	if reportRequest.Temperature != "" {
		report.Temperature = reportRequest.Temperature
	}

	if reportRequest.Systole != "" {
		report.Systole = reportRequest.Systole
	}

	if reportRequest.Diastole != "" {
		report.Diastole = reportRequest.Diastole
	}

	if reportRequest.Pulse != "" {
		report.Pulse = reportRequest.Pulse
	}

	if reportRequest.Respiration != "" {
		report.Respiration = reportRequest.Respiration
	}

	if reportRequest.SizeCircumference != 0 {
		report.SizeCircumference = reportRequest.SizeCircumference
	}

	if reportRequest.Allergy != "" {
		report.Allergy = reportRequest.Allergy
	}

	if reportRequest.IsChecked != nil {
		report.IsChecked = reportRequest.IsChecked

	}

	log.Printf("Updated Report: %+v", report) // Log data before saving

	errUpdate := database.DB.Save(&report).Error
	if errUpdate != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal Server Error",
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "success updating data",
		"data":    report,
	})
}

func DeleteNurseReport(ctx *fiber.Ctx) error {
	reportID := ctx.Params("id")

	// Start a transaction
	tx := database.DB.Begin()

	// Delete related doctor reports first
	if err := tx.Where("nurse_report_id = ?", reportID).Delete(&entity.DoctorReport{}).Error; err != nil {
		tx.Rollback()
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Failed to delete related Doctor Reports",
		})
	}

	// Delete the nurse report
	if err := tx.Delete(&entity.NurseReport{}, "id = ?", reportID).Error; err != nil {
		tx.Rollback()
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Failed to delete Nurse Report",
		})
	}

	// Commit the transaction
	if err := tx.Commit().Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Failed to commit transaction",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "Nurse Report and related Doctor Reports deleted successfully",
	})
}

func GetUserDataForReport(ctx *fiber.Ctx) error {
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
