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

func StaffLoginHandler(ctx *fiber.Ctx) error {
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
	var staff entity.Staff

	err := database.DB.First(&staff, "username = ?", loginRequest.Username).Error
	log.Println(err)
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "username not found",
		})
	}

	// CHECK VALIDATION PASSWORD
	isValid := utils.CheckPasswordHash(loginRequest.Password, staff.Password)
	if !isValid {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "wrong password",
		})
	}

	//GENERATE JWT (don't forget to install package : github.com/dgrijalva/jwt-go)
	claims := jwt.MapClaims{}
	claims["name"] = staff.Name
	claims["age"] = staff.Age
	claims["weight"] = staff.Weight
	claims["height"] = staff.Height
	claims["nip"] = staff.NIP
	claims["birthday"] = staff.Birthday
	claims["gender"] = staff.Gender
	claims["address"] = staff.Address
	claims["phone"] = staff.Phone
	claims["username"] = staff.Username
	claims["role"] = staff.Role
	claims["exp"] = time.Now().Add(5 * time.Minute).Unix()

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
