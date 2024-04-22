package handler

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"github.com/khensin166/PA2-Kel9/model/request"
	"github.com/khensin166/PA2-Kel9/utils"
	"log"
	"time"
)

func LoginHandler(ctx *fiber.Ctx) error {
	loginRequest := new(request.LoginRequest)

	// Menangani error saat parsing request body
	if err := ctx.BodyParser(loginRequest); err != nil {
		return err
	}

	//VALIDATION REQUEST
	validate := validator.New()
	errValidate := validate.Struct(loginRequest)

	if errValidate != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"mesage": "failed",
			"error":  errValidate.Error(),
		})
	}

	// CHECK AVAILABLE USER
	var user entity.User

	err := database.DB.First(&user, "username = ?", loginRequest.Username).Error

	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "username not found",
		})
	}

	// CHECK VALIDATION PASSWORD
	isValid := utils.CheckPasswordHash(loginRequest.Password, user.Password)
	if !isValid {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "wrong password",
		})
	}

	//GENERATE JWT (don't forget to install package : github.com/dgrijalva/jwt-go)
	claims := jwt.MapClaims{}
	claims["name"] = user.Name
	claims["age"] = user.Age
	claims["weight"] = user.Weight
	claims["height"] = user.Height
	claims["nik"] = user.NIK
	claims["birthday"] = user.Birthday
	claims["gender"] = user.Gender
	claims["address"] = user.Address
	claims["phone"] = user.Phone
	claims["username"] = user.Username
	claims["exp"] = time.Now().Add(5 * time.Minute).Unix()

	claims["role"] = user.Role

	token, errGenerateToken := utils.GenerateToken(&claims)

	if errGenerateToken != nil {
		log.Println(errGenerateToken)
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "wrong credentials",
		})

	}

	return ctx.JSON(fiber.Map{
		"token": token,
	})

}
