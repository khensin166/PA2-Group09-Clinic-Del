package handler

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"gorm.io/gorm"
)

func GetAllMedicalHistory(c *fiber.Ctx) error {
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	id := claims["id"].(uint)

	db := c.Locals("db").(*gorm.DB)
	var medicalHistories []entity.MedicalHistory
	result := db.Preload("DoctorReport.StaffDoctor").Preload("DoctorReport.Medicine").Where("user_id = ?", id).Find(&medicalHistories)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error.Error(),
		})
	}

	var response []map[string]interface{}
	for _, history := range medicalHistories {
		response = append(response, map[string]interface{}{
			"medical_history_id": history.ID,
			"staff_doctor_name":  history.DoctorReport.StaffDoctor.Name,
			"medicine_name":      history.DoctorReport.Medicine.Name,
			"disease":            history.DoctorReport.Disease,
			"amount":             history.DoctorReport.Amount,
		})
	}

	return c.Status(fiber.StatusOK).JSON(response)
}
