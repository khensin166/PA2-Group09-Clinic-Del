package handler

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"github.com/khensin166/PA2-Kel9/utils"
	"time"
)

func ReminderGetByAuth(ctx *fiber.Ctx) error {
	// Mendapatkan parameter tanggal dari request
	dateReq := ctx.Params("date")

	// Parse parameter tanggal menjadi tipe time.Time
	date, err := time.Parse("2006-01-02", dateReq)
	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "invalid date format, should be YYYY-MM-DD",
		})
	}

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
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated",
		})
	}

	// Mendapatkan ID pengguna dari token
	userID := int(claims["id"].(float64))

	// Melakukan query ke basis data untuk mendapatkan reminder yang sesuai dengan ID pengguna
	var reminders []entity.Reminder
	err = database.DB.Preload("User").Where("user_id = ?", userID).Find(&reminders).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "reminders not found",
		})
	}

	// Membuat slice baru untuk menyimpan data reminder yang akan dikirim ke client
	var responseReminders []fiber.Map
	for _, reminder := range reminders {
		// Parse StartDate dari string menjadi time.Time
		startDate, err := time.Parse("2006-01-02", reminder.StartDate)
		if err != nil {
			return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "internal error",
				"error":   err.Error(),
			})
		}

		// Bandingkan startDate dengan date dari parameter
		if startDate.Equal(date) {
			responseReminder := fiber.Map{
				"id":          reminder.ID,
				"first_time":  reminder.FirstTime,
				"second_time": reminder.SecondTime,
				"third_time":  reminder.ThirdTime,
				"name":        reminder.Name,
				"start_date":  reminder.StartDate,
				"duration":    reminder.Duration,
			}
			responseReminders = append(responseReminders, responseReminder)
		}
	}

	// Jika tidak ada reminder yang ditemukan, kembalikan pesan not found
	if len(responseReminders) == 0 {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "no reminders found for the given date",
		})
	}

	// Mengembalikan data reminder dalam format JSON
	return ctx.JSON(fiber.Map{
		"message": "success",
		"data":    responseReminders,
	})
}

func CreateReminder(ctx *fiber.Ctx) error {
	reminder := &entity.Reminder{}

	if err := ctx.BodyParser(reminder); err != nil {
		return err
	}

	// VALIDATION Request
	validate := validator.New()
	if err := validate.Struct(reminder); err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "failed",
			"error":   err.Error(),
		})
	}

	// Parse start date
	startDate, err := time.Parse("2006-01-02", reminder.StartDate)
	if err != nil {
		return ctx.Status(400).JSON(fiber.Map{
			"message": "invalid start_date format, should be YYYY-MM-DD",
			"error":   err.Error(),
		})
	}

	// Create reminders for the duration
	for i := 0; i < int(reminder.Duration); i++ {
		newReminder := *reminder // Make a copy of the reminder
		newReminder.StartDate = startDate.AddDate(0, 0, i).Format("2006-01-02")

		if err := database.DB.Debug().Create(&newReminder).Error; err != nil {
			return ctx.Status(500).JSON(fiber.Map{
				"message": "failed to store data",
				"error":   err.Error(),
			})
		}
	}

	response := entity.ReminderResponse{
		ID:         reminder.ID,
		UserID:     reminder.UserID,
		Name:       reminder.Name,
		FirstTime:  reminder.FirstTime,
		SecondTime: reminder.SecondTime,
		ThirdTime:  reminder.ThirdTime,
		StartDate:  reminder.StartDate,
		Duration:   reminder.Duration,
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "success",
		"data":    response,
	})
}

func UpdateReminder(ctx *fiber.Ctx) error {
	reminderRequest := new(entity.Reminder)

	if err := ctx.BodyParser(reminderRequest); err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "bad request",
		})
	}

	var reminder entity.Reminder

	reminderID := ctx.Params("id")

	// Fetch the reminder by ID
	err := database.DB.Debug().First(&reminder, "id = ?", reminderID).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "reminder not found",
		})
	}

	// Find all reminders with the same name as the fetched reminder
	var remindersWithSameName []entity.Reminder
	err = database.DB.Debug().Where("name = ?", reminder.Name).Find(&remindersWithSameName).Error
	if err != nil {
		return ctx.Status(404).JSON(fiber.Map{
			"message": "reminders with the same name not found",
		})
	}

	// Update the specific reminder by ID
	reminder.Name = reminderRequest.Name
	reminder.FirstTime = reminderRequest.FirstTime
	reminder.SecondTime = reminderRequest.SecondTime
	reminder.ThirdTime = reminderRequest.ThirdTime
	reminder.StartDate = reminderRequest.StartDate
	reminder.Duration = reminderRequest.Duration

	errUpdate := database.DB.Save(&reminder).Error
	if errUpdate != nil {
		return ctx.Status(500).JSON(fiber.Map{
			"message": "internal server error",
		})
	}

	// Update all other reminders with the same name
	for _, sameNameReminder := range remindersWithSameName {
		// Skip the reminder that was updated by ID
		if sameNameReminder.ID == reminder.ID {
			continue
		}

		sameNameReminder.Name = reminderRequest.Name
		sameNameReminder.FirstTime = reminderRequest.FirstTime
		sameNameReminder.SecondTime = reminderRequest.SecondTime
		sameNameReminder.ThirdTime = reminderRequest.ThirdTime
		sameNameReminder.Duration = reminderRequest.Duration

		if err := database.DB.Save(&sameNameReminder).Error; err != nil {
			return ctx.Status(500).JSON(fiber.Map{
				"message": "failed to update reminder with same name",
				"error":   err.Error(),
			})
		}
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "success",
		"data":    reminder,
	})
}

func DeleteReminder(ctx *fiber.Ctx) error {
	id := ctx.Params("id")

	var reminder entity.Reminder

	// Fetch the reminder by ID
	if err := database.DB.First(&reminder, id).Error; err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "reminder not found",
		})
	}

	// Find all reminders with the same name as the fetched reminder
	var remindersWithSameName []entity.Reminder
	if err := database.DB.Where("id = ?", id).Find(&remindersWithSameName).Error; err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to find reminders with the same name",
			"error":   err.Error(),
		})
	}

	// Delete all reminders with the same name
	if err := database.DB.Where("name = ?", reminder.Name).Delete(&entity.Reminder{}).Error; err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to delete reminders",
			"error":   err.Error(),
		})
	}

	return ctx.Status(200).JSON(fiber.Map{
		"message": "reminders deleted successfully",
	})
}
