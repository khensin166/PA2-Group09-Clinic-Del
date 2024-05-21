package handler

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/middleware"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"github.com/khensin166/PA2-Kel9/model/request"
	"github.com/khensin166/PA2-Kel9/utils"
	"log"
	"time"
)

func LoginHandler(ctx *fiber.Ctx) error {
	// Ambil token dari header Authorization
	token := ctx.Get("Authorization")

	// Periksa apakah token masih aktif
	if isActiveToken(token) {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "token masih aktif",
		})
	}

	// Melanjutkan proses login jika token tidak aktif

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
			"message": "invalid credentials",
			"error":   errValidate.Error(),
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

	claims := jwt.MapClaims{}
	claims["id"] = user.ID
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
	claims["role"] = user.Role
	claims["profilePicture"] = user.ProfilePicture
	claims["exp"] = time.Now().Add(24 * time.Hour).Unix()

	token, errGenerateToken := utils.GenerateToken(&claims)

	if errGenerateToken != nil {
		log.Println(errGenerateToken)
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "wrong credentials",
		})
	}

	// Set the Authorization header with the Bearer token
	ctx.Set("Authorization", ""+token)

	cookie := fiber.Cookie{
		Name:     "jwt",
		Value:    token,
		Expires:  time.Now().Add(time.Hour * 2),
		HTTPOnly: true,
	}

	ctx.Cookie(&cookie)

	// Tambahkan token ke ActiveTokens
	middleware.ActiveTokens[token] = true

	return ctx.Status(200).JSON(fiber.Map{
		"message": "success login",
		"data":    claims,
		"token":   token,
	})
}

func isActiveToken(token string) bool {
	// Periksa apakah token ada dalam daftar ActiveTokens
	_, isActive := middleware.ActiveTokens[token]
	return isActive
}

func LogoutHandler(ctx *fiber.Ctx) error {
	// Ambil token dari header Authorization
	authHeader := ctx.Get("Authorization")

	// Verifikasi token
	_, err := utils.VerifyToken(authHeader)
	if err != nil {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "invalid token",
		})
	}

	// Hapus token dari daftar token aktif
	delete(middleware.ActiveTokens, authHeader)

	return ctx.Status(200).JSON(fiber.Map{
		"message": "logout successful",
	})
}
