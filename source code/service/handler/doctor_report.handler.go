package handler

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"github.com/khensin166/PA2-Kel9/utils"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
	"log"
)

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

func CreateDoctorReport(ctx *fiber.Ctx) error {
	var doctorReport entity.DoctorReport

	if err := ctx.BodyParser(&doctorReport); err != nil {
		return err
	}

	validate := validator.New()
	if err := validate.Struct(doctorReport); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "failed",
			"error":   err.Error(),
		})
	}

	//VALIDATION
	// membuat token
	token := ctx.Get("Authorization")
	if token == "" {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated",
		})
	}

	claims, err := utils.DecodeToken(token)
	if err != nil {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated err",
		})
	}

	role := claims["role"].(float64)
	if role == 1 {
		return ctx.Status(fiber.StatusForbidden).JSON(fiber.Map{
			"message": "Nurse	 can't create the data",
		})
	}

	// Create the DoctorReport
	if err := database.DB.Create(&doctorReport).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "failed to store data",
			"error":   err.Error(),
		})
	}

	// Update Medicine stock
	for _, medicine := range doctorReport.Medicines {
		var dbMedicine entity.Medicine
		if err := database.DB.First(&dbMedicine, medicine.ID).Error; err != nil {
			return ctx.Status(400).SendString("Obat tidak ditemukan")
		}

		if dbMedicine.Amount < medicine.Amount {
			return ctx.Status(400).SendString("Stok obat tidak cukup")
		}

		dbMedicine.Amount -= medicine.Amount
		if err := database.DB.Save(&dbMedicine).Error; err != nil {
			return ctx.Status(500).JSON(fiber.Map{
				"message": "failed to update medicine stock",
				"error":   err.Error(),
			})
		}

		// Assign medicine to the current doctor report
		if err := database.DB.Model(&doctorReport).Association("Medicines").Append(&dbMedicine); err != nil {
			return ctx.Status(500).JSON(fiber.Map{
				"message": "failed to associate medicine with doctor report",
				"error":   err.Error(),
			})
		}
	}

	// Load relations
	if err := database.DB.Preload("NurseReport").Preload("StaffDoctor").Preload("Medicines").First(&doctorReport, doctorReport.ID).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "failed to load relations",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(doctorReport)
}

func UpdateDoctorReport(ctx *fiber.Ctx) error {
	reportRequest := new(entity.DoctorReportResponse)
	if err := ctx.BodyParser(reportRequest); err != nil {
		return ctx.Status(400).JSON(fiber.Map{"message": "Bad request"})
	}

	var report entity.DoctorReport

	reportID := ctx.Params("id")
	// CHECK AVAILABLE REPORT
	err := database.DB.First(&report, "id = ?", reportID).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "DoctorReport not found",
		})
	}

	// UPDATE REPORT DATA
	if reportRequest.Disease != "" {
		report.Disease = &reportRequest.Disease
	}
	if reportRequest.NurseReportID != 0 {
		report.NurseReportID = &reportRequest.NurseReportID
	}

	if reportRequest.StaffDoctorID != 0 {
		report.StaffDoctorID = &reportRequest.StaffDoctorID
	}

	if reportRequest.Disease != "" {
		report.Disease = &reportRequest.Disease
	}

	errUpdate := database.DB.Save(&report).Error

	if errUpdate != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Internal server error",
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "Success",
		"data":    report,
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
					NurseReportID: &nurseReport.ID,
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
			existingDoctorReport.NurseReportID = &nurseReport.ID
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
