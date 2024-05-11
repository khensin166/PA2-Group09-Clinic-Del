package handler

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"github.com/khensin166/PA2-Kel9/utils"
)

func DoctorReportGetAll(ctx *fiber.Ctx) error {
	var doctorReport []entity.DoctorReport

	database.DB.Preload("NurseReport").Preload("NurseReport.Patient").Preload("NurseReport.StaffNurse").Preload("StaffDoctor").Preload("Medicine").Find(&doctorReport)

	return ctx.Status(200).JSON(fiber.Map{
		"doctor_report": doctorReport,
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
			"message": "Doctor can't create the data",
		})
	}

	database.DB.Create(&doctorReport)

	var medicine entity.Medicine
	database.DB.First(&medicine, doctorReport.MedicineID)
	if medicine.Amount > 0 {
		medicine.Amount -= doctorReport.Amount
		if medicine.Amount > 0 {
			database.DB.Save(&medicine)
		} else {
			return ctx.Status(400).SendString("Stok obat tidak cukup")
		}

	} else {
		return ctx.Status(400).SendString("Stok obat tidak cukup")
	}

	// Load relations
	database.DB.Preload("NurseReport").Preload("StaffDoctor").Preload("Medicine").First(&doctorReport, doctorReport.ID)

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
		report.Disease = reportRequest.Disease
	}
	if reportRequest.NurseReportID != 0 {
		report.NurseReportID = reportRequest.NurseReportID
	}

	if reportRequest.MedicineID != 0 {
		report.MedicineID = reportRequest.MedicineID
	}
	if reportRequest.StaffDoctorID != 0 {
		report.StaffDoctorID = reportRequest.StaffDoctorID
	}

	if reportRequest.Disease != "" {
		report.Disease = reportRequest.Disease
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
