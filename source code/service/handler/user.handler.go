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
	"os"
	"path/filepath"
)

var PathImageUser = "./Public/User"

func init() {
	if _, err := os.Stat(PathImageUser); os.IsNotExist(err) {
		err := os.Mkdir(PathImageUser, os.ModePerm)
		if err != nil {
			return
		}
	}
}
func UserHandlerGetAll(ctx *fiber.Ctx) error {

	userInfo := ctx.Locals("userInfo")
	log.Println("user info data :: ", userInfo)

	// membuat slice untuk entity users
	var users []entity.User

	// memanggil DB pada package database (cara 1)
	result := database.DB.Find(&users)

	if result.Error != nil {
		log.Println(result.Error)
	}

	return ctx.Status(200).JSON(users)

}

func CreateUser(ctx *fiber.Ctx) error {
	// Parse form data
	user := new(entity.User)

	// Menangani error saat parsing request body
	if err := ctx.BodyParser(user); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"status":  "failed",
			"message": "Invalid form data",
		})
	}

	//VALIDATION REQUEST
	validate := validator.New()
	err := validate.Struct(user)

	if err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "failed",
			"error":   err.Error(),
		})
	}

	// pemanggilan hashed password
	hashedPassword, err := utils.HashingPassword(user.Password)
	if err != nil {
		log.Println(err)
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "internal server error",
		})
	}
	// passing password yang sudah di hasing ke entity user (JSON)
	user.Password = hashedPassword

	image, err := ctx.FormFile("profilePicture")

	if err == nil {
		filename := utils.GenerateImageFile(user.Name, image.Filename)
		if err := ctx.SaveFile(image, filepath.Join(PathImageUser, filename)); err != nil {
			return ctx.Status(500).JSON(fiber.Map{
				"status":  "failed",
				"message": "Can't save file image",
			})
		}
		user.ProfilePicture = &filename
	} else {
		user.ProfilePicture = nil
	}

	// Mencoba membuat entitas baru dan menangani errornya
	if err := database.DB.Create(&user).Error; err != nil {
		// Mengembalikan respon error 500 dengan pesan yang sesuai
		return ctx.Status(500).JSON(fiber.Map{
			"message": "failed to store data",
			"error":   err.Error(), // Menambahkan pesan error ke respon JSON
		})
	}

	// Mengembalikan respon sukses dengan data baru yang telah dibuat
	return ctx.Status(200).JSON(fiber.Map{
		"message": "success",
		"data":    user,
	})
}

func UserHandlerGetById(ctx *fiber.Ctx) error {

	// mencari user parameter id.
	userId := ctx.Params("id")

	// mendeklarasikan variabel user dengan tipe data userEntity
	var user entity.User

	// Query Statement dengan GORM
	err := database.DB.First(&user, "id = ?", userId).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "user not found",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    user,
	})
}

func UpdateUser(ctx *fiber.Ctx) error {
	// Parse form data
	userRequest := new(entity.User)
	if err := ctx.BodyParser(userRequest); err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "bad request",
		})
	}

	// Get user ID from URL
	var user entity.User
	// logic
	userID := ctx.Params("id")

	// CHECK AVAILABLE USER
	err := database.DB.First(&user, "id = ?", userID).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "user not found",
		})
	}

	// UPDATE USER DATA
	if userRequest.Name != "" {
		user.Name = userRequest.Name
	}
	user.Address = userRequest.Address

	user.Phone = userRequest.Phone
	user.Birthday = userRequest.Birthday
	user.Gender = userRequest.Gender
	user.Weight = userRequest.Weight
	user.Height = userRequest.Height
	user.NIK = userRequest.NIK

	// Process image if provided
	image, err := ctx.FormFile("profilePicture")
	if err == nil {
		filename := utils.GenerateImageFile(user.Username, image.Filename)
		if err := ctx.SaveFile(image, filepath.Join(PathImageUser, filename)); err != nil {
			return ctx.Status(500).JSON(fiber.Map{
				"status":  "failed",
				"message": "Can't save file image",
			})
		}
		user.ProfilePicture = &filename
	}

	validate := validator.New()
	if err := validate.Struct(user); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"status":  "failed",
			"message": err.Error(),
		})
	}

	// Update the medicine in the database
	if err := database.DB.Save(&user).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"status":  "failed",
			"message": "failed to update data",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "Profile berhasil diperbaharui",
		"data":    user,
	})
}

func DeleteUser(c *fiber.Ctx) error {
	id := c.Params("id")

	var user entity.User
	if err := database.DB.First(&user, id).Error; err != nil {
		log.Println(err)
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "User not found",
		})
	}

	if err := database.DB.Delete(&user).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to delete user",
		})
	}

	return c.JSON(fiber.Map{
		"message": "User deleted successfully",
	})
}

func UserHandlerProfile(ctx *fiber.Ctx) error {
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
		log.Println("Error decoding token:", err)
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated err",
		})
	}

	// Mendapatkan ID pengguna dari token
	userName, ok := claims["username"]
	if !ok {
		log.Println("Invalid token claims:", claims)
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "invalid token claims",
		})
	}

	// Melakukan query ke basis data untuk mendapatkan pengguna yang sesuai dengan ID pengguna
	var user entity.User
	result := database.DB.Where("username = ?", userName).First(&user)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			log.Println("User not found dek:", userName)
			return ctx.Status(404).JSON(fiber.Map{
				"message": "user not found",
			})
		}
		log.Println("Database error:", result.Error)
		return ctx.Status(500).JSON(fiber.Map{
			"message": "database error",
		})
	}

	// Mempersiapkan respons pengguna
	userResponse := entity.UserResponse{
		ID:             user.ID,
		DormID:         user.DormID,
		Name:           user.Name,
		Age:            user.Age,
		Weight:         user.Weight,
		Height:         user.Height,
		NIK:            user.NIK,
		Birthday:       user.Birthday,
		Gender:         user.Gender,
		Address:        user.Address,
		Phone:          user.Phone,
		Username:       user.Username,
		Password:       user.Password,
		Role:           user.Role,
		ProfilePicture: user.ProfilePicture,
	}

	// Mengembalikan data pengguna dalam format JSON
	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    userResponse,
	})
}

func UserHandlerProfilePicture(ctx *fiber.Ctx) error {
	userID := ctx.Params("id")
	var user entity.User

	err := database.DB.First(&user, "id = ?", userID).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "user not found",
		})
	}

	image, err := ctx.FormFile("profilePicture")
	if err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "No file provided",
		})
	}

	filename := utils.GenerateImageFile(user.Username, image.Filename)
	if err := ctx.SaveFile(image, filepath.Join(PathImageUser, filename)); err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "Can't save file image",
		})
	}
	user.ProfilePicture = &filename

	if err := database.DB.Save(&user).Error; err != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "failed to update profile picture",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "success",
		"image":   user.ProfilePicture,
		"status":  "200",
	})
}

func UserHandlerGetProfilePicture(ctx *fiber.Ctx) error {
	// Mendapatkan token dari body permintaan
	body := struct {
		Token string `json:"token"`
	}{}
	if err := ctx.BodyParser(&body); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "invalid request body",
		})
	}

	token := body.Token
	if token == "" {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated",
		})
	}

	// Mendekode token untuk mendapatkan informasi pengguna
	claims, err := utils.DecodeToken(token)
	if err != nil {
		log.Println("Error decoding token:", err)
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated err",
		})
	}

	// Mendapatkan ID pengguna dari token
	userName, ok := claims["username"]
	if !ok {
		log.Println("Invalid token claims:", claims)
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "invalid token claims",
		})
	}

	// Melakukan query ke basis data untuk mendapatkan pengguna yang sesuai dengan ID pengguna
	var user entity.User
	result := database.DB.Where("username = ?", userName).First(&user)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			log.Println("User not found:", userName)
			return ctx.Status(404).JSON(fiber.Map{
				"message": "user not found",
			})
		}
		log.Println("Database error:", result.Error)
		return ctx.Status(500).JSON(fiber.Map{
			"message": "database error",
		})
	}

	userResponse := entity.UserProfileResponse{
		Name:           user.Name,
		ID:             user.ID,
		Username:       user.Username,
		ProfilePicture: user.ProfilePicture,
	}

	// Mengembalikan data pengguna dalam format JSON
	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    userResponse,
		"status":  "200",
	})
}
