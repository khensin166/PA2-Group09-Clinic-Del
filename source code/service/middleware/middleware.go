package middleware

import (
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/utils"
)

func Auth(ctx *fiber.Ctx) error {
	// membuat token
	token := ctx.Get("Authorization")
	if token == "" {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated",
		})
	}

	//_, err := utils.VerifyToken(token)
	claims, err := utils.DecodeToken(token)
	if err != nil {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated err",
		})
	}

	//ctx.Locals("userInfo", claims)
	role := claims["role"].(string)
	if role != "admin" {
		return ctx.Status(fiber.StatusForbidden).JSON(fiber.Map{
			"message": "forbidden access",
		})
	}

	ctx.Locals("userInfo", claims)

	return ctx.Next()
}

func PermissionCreate(ctx *fiber.Ctx) error {
	return ctx.Next()
}
