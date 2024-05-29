package handler

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
	"log"
)

func DoctorReportGetById(ctx *fiber.Ctx) error {
	doctorReportId := ctx.Params("id")
	// mendeklarasikan variabel user dengan tipe data userEntity
	var doctorReport entity.DoctorReport

	// Query Statement dengan GORM
	err := database.DB.Preload("NurseReport").
		Preload("StaffDoctor").
		Preload("NurseReport.Patient").
		Preload("NurseReport.StaffNurse").
		Preload("Medicine").
		First(&doctorReport, "id = ?", doctorReportId).Error
	if err != nil {
		// Log the actual error for debugging purposes
		log.Println("Error fetching DoctorReport:", err)
		return ctx.Status(404).JSON(fiber.Map{
			"message": "doctor report not found",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    doctorReport,
	})
}

func DoctorReportGetAll(ctx *fiber.Ctx) error {
	var doctorReports []entity.DoctorReport

	if err := database.DB.Preload("NurseReport").
		Preload("NurseReport.Patient").
		Preload("NurseReport.StaffNurse").
		Preload("StaffDoctor").
		Preload("Medicines"). // Preload medicines association
		Find(&doctorReports).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "failed to fetch doctor reports",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"doctor_reports": doctorReports,
	})
}

func UpdateDoctorReport(ctx *fiber.Ctx) error {
	input := new(entity.DoctorReport)
	if err := ctx.BodyParser(input); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"status":  "failed",
			"message": "Invalid form data",
		})
	}

	// Get doctor report ID from URL
	doctorReportID := ctx.Params("id")
	var doctorReport entity.DoctorReport

	// Find the existing doctor report record
	if err := database.DB.First(&doctorReport, "id = ?", doctorReportID).Error; err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"status":  "failed",
			"message": "doctor report not found",
		})
	}

	// Update fields
	if input.Disease != "" {
		doctorReport.Disease = input.Disease
	}

	if input.Amount != 0 {
		// Get the associated medicine record
		var medicine entity.Medicine
		if err := database.DB.First(&medicine, "id = ?", input.MedicineID).Error; err != nil {
			return ctx.Status(404).JSON(fiber.Map{
				"status":  "failed",
				"message": "medicine not found",
			})
		}

		// Update the amount of the medicine
		medicine.Amount -= input.Amount - doctorReport.Amount
		if medicine.Amount < 0 {
			return ctx.Status(400).JSON(fiber.Map{
				"status":  "failed",
				"message": "insufficient medicine amount",
			})
		}

		doctorReport.Amount = input.Amount

		// Save the updated medicine record
		if err := database.DB.Save(&medicine).Error; err != nil {
			return ctx.Status(500).JSON(fiber.Map{
				"status":  "failed",
				"message": "failed to update medicine amount",
				"error":   err.Error(),
			})
		}
	}

	// Ensure MedicineID is set correctly
	if input.MedicineID != 0 {
		doctorReport.MedicineID = input.MedicineID
	}

	// Validate only the necessary fields of the doctor report
	validate := validator.New()
	if err := validate.StructPartial(doctorReport, "Disease", "Amount", "MedicineID"); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"status":  "failed",
			"message": err.Error(),
		})
	}

	// Update the doctor report in the database
	if err := database.DB.Save(&doctorReport).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"status":  "failed",
			"message": "failed to update doctor report",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"status": "success",
		"data":   doctorReport,
	})
}

func DeleteDoctorReport(ctx *fiber.Ctx) error {
	reportID := ctx.Params("id")

	var report entity.DoctorReport
	if err := database.DB.First(&report, reportID).Error; err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"error": "DoctorReport not found",
		})
	}

	if err := database.DB.Delete(&report).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"error": "Failed to delete DoctorReport",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "DoctorReport deleted successfully",
	})
}

func GetUserDataForReportDoctor(ctx *fiber.Ctx) error {
	var nurseReports []entity.NurseReport

	// Fetch all nurse reports that meet the criteria
	if err := database.DB.Where("is_checked IS NOT NULL").Preload("Patient").Preload("StaffNurse").Find(&nurseReports).Error; err != nil {
		log.Println("Error fetching nurse reports:", err)
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Error fetching nurse reports",
		})
	}

	// Slice to hold the response data
	var doctorReportsData []entity.DoctorReport

	// Process each fetched nurse report
	for _, nurseReport := range nurseReports {
		// Check if the nurse report ID is valid
		if nurseReport.ID == 0 {
			log.Println("Skipping nurse report with invalid ID:", nurseReport)
			continue
		}

		var existingDoctorReport entity.DoctorReport

		if err := database.DB.Where("nurse_report_id = ?", nurseReport.ID).Preload(clause.Associations).Preload("NurseReport").Preload("NurseReport.Patient").Preload("NurseReport.StaffNurse").First(&existingDoctorReport).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				// Create a new doctor report if not found
				newDoctorReport := entity.DoctorReport{
					NurseReportID: nurseReport.ID,
					StaffDoctorID: nil, // Initialize with NULL value
				}
				if err := database.DB.Create(&newDoctorReport).Error; err != nil {
					log.Println("Error creating doctor report:", err)
					return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
						"message": "Error creating doctor reports",
					})
				}
				doctorReportsData = append(doctorReportsData, newDoctorReport)
			} else {
				log.Println("Error fetching doctor report:", err)
				return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"message": "Error fetching doctor report",
				})
			}
		} else {
			// Log the staff ID being updated
			log.Println("Updating doctor report for staff ID:", nurseReport.StaffNurseID)

			// Update the existing doctor report with the nurse report ID
			existingDoctorReport.NurseReportID = nurseReport.ID
			if err := database.DB.Save(&existingDoctorReport).Error; err != nil {
				log.Println("Error updating doctor report:", err)
				return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"message": "Error updating doctor reports",
				})
			}
			doctorReportsData = append(doctorReportsData, existingDoctorReport)
		}
	}

	// Return the doctor reports data as a JSON response
	return ctx.Status(fiber.StatusOK).JSON(fiber.Map{
		"message":        "Successfully fetched doctor reports",
		"doctor_reports": doctorReportsData,
	})
}

func UpdateApprovedDoctorID(ctx *fiber.Ctx) error {
	// Get the ID from the URL
	id := ctx.Params("id")

	// Find the doctor report in the database
	doctorReport := new(entity.DoctorReport)
	if err := database.DB.First(&doctorReport, id).Error; err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "Doctor report not found",
			"error":   err.Error(),
		})
	}

	// Parse the updated data
	var updatedData struct {
		StaffDoctorID uint `json:"staff_doctor_id"`
	}
	if err := ctx.BodyParser(&updatedData); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "Error parsing data",
			"error":   err.Error(),
		})
	}

	// Validate the parsed data
	if updatedData.StaffDoctorID == 0 {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "staff_doctor_id is required",
		})
	}

	// Update the doctor report in the database
	doctorReport.StaffDoctorID = &updatedData.StaffDoctorID

	if err := database.DB.Save(&doctorReport).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Failed to update data",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message":      "Updated data successfully",
		"doctorReport": doctorReport,
	})
}
