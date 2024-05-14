package handler

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
)

func MedicineGetAll(ctx *fiber.Ctx) error {
	var medicines []entity.Medicine

	database.DB.Find(&medicines)

	// Create a slice to store the response data
	response := make([]fiber.Map, len(medicines))

	// Iterate through medicines and populate response with required fields
	for i, medicine := range medicines {
		response[i] = fiber.Map{
			"id":      medicine.ID,
			"name":    medicine.Name,
			"amount":  medicine.Amount,
			"expired": medicine.Expired,
		}
	}

	return ctx.Status(200).JSON(fiber.Map{
		"medicine": response,
	})
}

func CreateMedicine(ctx *fiber.Ctx) error {
	medicine := &entity.Medicine{}

	if err := ctx.BodyParser(medicine); err != nil {
		return err
	}

	// VALIDATION Request
	validate := validator.New()
	if err := validate.Struct(medicine); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "failed",
			"error":   err.Error(),
		})
	}

	// Create the Medicine
	if err := database.DB.Create(medicine).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "failed to store data",
			"error":   err.Error(),
		})
	}

	response := entity.Medicine{
		ID:      medicine.ID,
		Name:    medicine.Name,
		Amount:  medicine.Amount,
		Expired: medicine.Expired,
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "success",
		"data":    response,
	})
}

func UpdateMedicine(ctx *fiber.Ctx) error {

	medicineRequest := new(entity.Medicine)

	if err := ctx.BodyParser(medicineRequest); err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "bad request",
		})
	}

	var medicine entity.Medicine

	medicineID := ctx.Params("id")

	err := database.DB.First(&medicine, "id = ?", medicineID).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "medicine not found",
		})
	}

	// UPDATE USER DATA
	if medicine.Name != "" {
		medicine.Name = medicineRequest.Name
	}

	if medicine.Amount != 0 {
		medicine.Amount = medicineRequest.Amount
	}

	if medicine.Expired != "" {
		medicine.Expired = medicineRequest.Expired
	}

	errUpdate := database.DB.Save(&medicine).Error

	if errUpdate != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "internal server error",
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "success",
		"data":    medicine,
	})

}

func DeleteMedicine(ctx *fiber.Ctx) error {
	id := ctx.Params("id")

	var medicine entity.Medicine

	if err := database.DB.First(&medicine, id).Error; err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "medicine not found",
		})
	}

	if err := database.DB.Delete(&medicine).Error; err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to delete medicine",
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "Medicine deleted successfully",
	})
}
