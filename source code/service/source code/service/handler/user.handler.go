package handler

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"github.com/khensin166/PA2-Kel9/model/request"
	"github.com/khensin166/PA2-Kel9/utils"
	"log"
)

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

	// memanggil DB pada package database (cara 2)
	//err := database.DB.Find(&users).Error
	//if err != nil {
	//	log.Println(err)
	//}

	return ctx.JSON(users)

}

func UserHandlerCreate(ctx *fiber.Ctx) error {
	user := new(request.UserCreateRequest)

	// Menangani error saat parsing request body
	if err := ctx.BodyParser(user); err != nil {
		return err
	}

	//VALIDATION REQUEST
	validate := validator.New()
	err := validate.Struct(user)

	if err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"mesage": "failed",
			"error":  err.Error(),
		})
	}

	newUser := entity.User{
		Name:     user.Name,
		Age:      user.Age,
		Weight:   user.Weight,
		Height:   user.Height,
		NIK:      user.NIK,
		Birthday: user.Birthday,
		Gender:   user.Gender,
		Address:  user.Address,
		Phone:    user.Phone,
		Username: user.Username,
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
	newUser.Password = hashedPassword

	// Mencoba membuat entitas baru dan menangani errornya
	if err := database.DB.Create(&newUser).Error; err != nil {
		// Mengembalikan respon error 500 dengan pesan yang sesuai
		return ctx.Status(500).JSON(fiber.Map{
			"message": "failed to store data",
			"error":   err.Error(), // Menambahkan pesan error ke respon JSON
		})
	}

	// Mengembalikan respon sukses dengan data baru yang telah dibuat
	return ctx.Status(200).JSON(fiber.Map{
		"message": "success",
		"data":    newUser,
	})
}

func UserHandlerGetById(ctx *fiber.Ctx) error {

	// mencari user parameter id.
	userId := ctx.Params("id")

	// mendeklarasikan variabel user dengan tipe data userEntity
	var user entity.User

	// Query Statement dengan GORM
	err := database.DB.First(&user, "?", userId).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "user not found",
		})
	}

	//userResponse := response.UserResponse{
	//	ID:        user.ID,
	//	Name:      user.Name,
	//	Email:     user.Email,
	//	Address:   user.Address,
	//	Phone:     user.Phone,
	//	CreatedAt: user.CreatedAt,
	//	UpdatedAt: user.UpdatedAt,
	//}

	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    user,
	})
}

func UserHandlerUpdate(ctx *fiber.Ctx) error {

	userRequest := new(request.UserUpdateRequest)
	if err := ctx.BodyParser(userRequest); err != nil {
		return ctx.Status(404).JSON(fiber.Map{"message": "bad request"})
	}

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
	errUpdate := database.DB.Save(&user).Error

	if errUpdate != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "internal server error",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    user,
	})
}
