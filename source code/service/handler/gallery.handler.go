package handler

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"github.com/khensin166/PA2-Kel9/utils"
	"os"
	"path/filepath"
)

//var PathImageProduct = "./Public/Product"

func init() {
	if _, err := os.Stat(PathImageProduct); os.IsNotExist(err) {
		err := os.Mkdir(PathImageProduct, os.ModePerm)
		if err != nil {
			return
		}
	}
}
func GalleryHandlerGetById(ctx *fiber.Ctx) error {
	galleryId := ctx.Params("id")
	var gallery entity.Gallery

	err := database.DB.First(&gallery, "id = ?", galleryId).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "gallery not found",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    gallery,
	})
}

func GalleryGetAll(ctx *fiber.Ctx) error {
	var galleries []entity.Gallery

	database.DB.Find(&galleries)

	response := make([]fiber.Map, len(galleries))
	for i, gallery := range galleries {
		response[i] = fiber.Map{
			"id":        gallery.ID,
			"picture_1": gallery.Picture1,
		}
	}

	return ctx.Status(200).JSON(fiber.Map{
		"galleries": response,
	})
}

func CreateGallery(ctx *fiber.Ctx) error {
	input := new(entity.Gallery)
	if err := ctx.BodyParser(input); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"status":  "failed",
			"message": "Invalid form data",
		})
	}

	validate := validator.New()
	if err := validate.Struct(input); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"status":  "failed",
			"message": err.Error(),
		})
	}

	image, err := ctx.FormFile("image")
	if err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"status":  "failed",
			"message": "Image is required",
		})
	}

	filename := utils.GenerateImageFile(input.Picture1, image.Filename)
	if err := ctx.SaveFile(image, filepath.Join(PathImageProduct, filename)); err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"status":  "failed",
			"message": "Can't save file image",
		})
	}
	input.Picture1 = filename

	if err := database.DB.Create(input).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"status":  "failed",
			"message": "failed to store data",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"status": "success",
		"data":   input,
	})
}

func UpdateGallery(ctx *fiber.Ctx) error {
	input := new(entity.Gallery)
	if err := ctx.BodyParser(input); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"status":  "failed",
			"message": "Invalid form data",
		})
	}

	galleryID := ctx.Params("id")
	var gallery entity.Gallery

	if err := database.DB.First(&gallery, "id = ?", galleryID).Error; err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"status":  "failed",
			"message": "gallery not found",
		})
	}

	image, err := ctx.FormFile("image")
	if err == nil {
		filename := utils.GenerateImageFile("image_of_", image.Filename)
		if err := ctx.SaveFile(image, filepath.Join(PathImageProduct, filename)); err != nil {
			return ctx.Status(500).JSON(fiber.Map{
				"status":  "failed",
				"message": "Can't save file image",
			})
		}
		gallery.Picture1 = filename
	}

	if err := database.DB.Save(&gallery).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"status":  "failed",
			"message": "failed to update data",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"status": "success",
		"data":   gallery,
	})
}

func DeleteGallery(ctx *fiber.Ctx) error {
	id := ctx.Params("id")

	var gallery entity.Gallery

	if err := database.DB.First(&gallery, "id = ?", id).Error; err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "gallery not found",
		})
	}

	if err := database.DB.Delete(&gallery).Error; err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to delete gallery",
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "gallery deleted successfully",
	})
}
