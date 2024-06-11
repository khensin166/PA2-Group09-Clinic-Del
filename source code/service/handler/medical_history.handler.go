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

func MedicalHistoryGetById(ctx *fiber.Ctx) error {
	medicalHistoryId := ctx.Params("id")
	// mendeklarasikan variabel user dengan tipe data userEntity
	var medicalHistory entity.MedicalHistory

	// Query Statement dengan GORM
	err := database.DB.Preload("DoctorReport").Preload("DoctorReport.NurseReport").Preload("DoctorReport.StaffDoctor").Preload("DoctorReport.Medicine").Preload("DoctorReport.NurseReport.Patient").Preload("DoctorReport.NurseReport.StaffNurse").First(&medicalHistory, "id = ?", medicalHistoryId).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "medicine not found",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    medicalHistory,
	})
}

func GetAllMedicalHistoryByToken(ctx *fiber.Ctx) error {
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

	i, ok := claims["id"]
	log.Println(i)

	if !ok {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to parse user ID",
		})
	}

	// membuat slice untuk entitas medical history
	var medicalHistory []entity.MedicalHistory

	// Memuat medical history yang sesuai dengan ID pengguna
	result := database.DB.Preload("User").Preload("DoctorReport").Preload("DoctorReport.NurseReport").Where("user_id = ?", i).Find(&medicalHistory)

	if result.Error != nil {
		log.Println(result.Error)
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to fetch medical history",
		})
	}

	return ctx.Status(200).JSON(medicalHistory)
}

func CreateMedicalHistory(ctx *fiber.Ctx) error {
	medicalHistory := new(entity.MedicalHistoryResponse)

	// Menangani error saat parsing request body
	if err := ctx.BodyParser(medicalHistory); err != nil {
		return err
	}

	//VALIDATION REQUEST
	validate := validator.New()
	err := validate.Struct(medicalHistory)

	if err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "failed",
			"error":   err.Error(),
		})
	}

	// Mencoba membuat entitas baru dan menangani errornya
	if err := database.DB.Create(&medicalHistory).Error; err != nil {
		// Mengembalikan respon error 500 dengan pesan yang sesuai
		return ctx.Status(500).JSON(fiber.Map{
			"message": "failed to store data",
			"error":   err.Error(), // Menambahkan pesan error ke respon JSON
		})
	}

	// Mengembalikan respon sukses dengan data baru yang telah dibuat
	return ctx.Status(200).JSON(fiber.Map{
		"message": "success",
		"data":    medicalHistory,
	})
}

func GetUserDataForMedicalHistory(ctx *fiber.Ctx) error {
	var doctorReports []entity.DoctorReport

	// Fetch all doctor reports that have a staff_doctor_id not null
	if err := database.DB.Where("staff_doctor_id IS NOT NULL").Preload(clause.Associations).Find(&doctorReports).Error; err != nil {
		log.Println("Error fetching doctor reports:", err)
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Error fetching doctor reports",
		})
	}

	// Slice to hold the response data
	var medicalHistoriesData []entity.MedicalHistory

	// Process each fetched doctor report
	for _, doctorReport := range doctorReports {
		// Check if the doctor report ID is valid
		if doctorReport.ID == 0 {
			log.Println("Skipping doctor report with invalid ID:", doctorReport)
			continue
		}

		var existingMedicalHistory entity.MedicalHistory

		if err := database.DB.Where("doctor_report_id = ?", doctorReport.ID).Preload(clause.Associations).Preload("DoctorReport").Preload("DoctorReport.NurseReport").Preload("DoctorReport.StaffDoctor").Preload("DoctorReport.Medicine").Preload("DoctorReport.NurseReport.Patient").Preload("DoctorReport.NurseReport.StaffNurse").First(&existingMedicalHistory).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				// Create a new medical history if not found
				newMedicalHistory := entity.MedicalHistory{
					UserID:         doctorReport.NurseReport.PatientID, // Assuming PatientID is present in NurseReport
					DoctorReportID: doctorReport.ID,
				}
				if err := database.DB.Create(&newMedicalHistory).Error; err != nil {
					log.Println("Error creating medical history:", err)
					return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
						"message": "Error creating medical histories",
					})
				}
				medicalHistoriesData = append(medicalHistoriesData, newMedicalHistory)
			} else {
				log.Println("Error fetching medical history:", err)
				return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"message": "Error fetching medical history",
				})
			}
		} else {
			// Update the existing medical history with the doctor report ID
			existingMedicalHistory.DoctorReportID = doctorReport.ID
			if err := database.DB.Save(&existingMedicalHistory).Error; err != nil {
				log.Println("Error updating medical history:", err)
				return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"message": "Error updating medical histories",
				})
			}
			medicalHistoriesData = append(medicalHistoriesData, existingMedicalHistory)
		}
	}

	// Return the medical histories data as a JSON response
	return ctx.Status(fiber.StatusOK).JSON(fiber.Map{
		"message":           "Successfully fetched medical histories",
		"medical_histories": medicalHistoriesData,
	})
}
