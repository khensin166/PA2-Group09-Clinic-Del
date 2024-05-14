package route

import (
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/handler"
	"github.com/khensin166/PA2-Kel9/middleware"
)

func RouteInit(r *fiber.App) {
	// AUTHENTICATION
	r.Post("/userLogin", handler.LoginHandler)
	r.Post("/userLogout", handler.LogoutHandler)

	r.Post("/staffLogin", handler.StaffLoginHandler)
	r.Post("/staffLogout", handler.StaffLogoutHandler)

	// USER
	r.Get("/users", middleware.StaffAuth, handler.UserHandlerGetAll)
	r.Get("/user/:id", middleware.StaffAuth, handler.UserHandlerGetById)
	r.Post("/user", handler.CreateUser)
	r.Put("/user/:id", middleware.Auth, handler.UpdateUser)
	r.Delete("/user/:id", middleware.StaffAuth, handler.DeleteUser)

	// APPOINTMENT
	r.Get("/appointments", handler.AppointmentGetAll)
	r.Get("/appointments-auth", middleware.Auth, handler.AppointmentGetByAuth)
	r.Post("/appointment", middleware.Auth, handler.CreateAppointment)
	r.Put("/appointment/:id/approve", middleware.StaffAuth, handler.UpdateApprovedID)
	r.Put("/appointment/:id", middleware.Auth, handler.UpdateAppointment)
	r.Delete("/appointment/:id", middleware.Auth, handler.DeleteAppointment)

	// STAFF
	r.Get("/staffs", middleware.StaffAuth, handler.StaffHandlerGetAll)
	r.Get("/staff/:id", middleware.StaffAuth, handler.StaffHandlerGetById)
	r.Post("/staff", handler.CreateStaff)
	r.Put("/staff/:id", middleware.StaffAuth, handler.UpdateStaff)
	r.Delete("/staff/:id", middleware.StaffAuth, handler.DeleteStaff)

	// MEDICINE
	r.Get("/medicines", middleware.StaffAuth, handler.MedicineGetAll)
	r.Post("/medicine", middleware.StaffAuth, handler.CreateMedicine)
	r.Put("/medicine/:id", middleware.StaffAuth, handler.UpdateMedicine)
	r.Delete("/medicine/:id", middleware.StaffAuth, handler.DeleteMedicine)

	// NURSE REPORT
	r.Get("/nurse-reports", middleware.StaffAuth, handler.NurseReportGetAll)
	r.Post("/nurse-report", middleware.StaffAuth, handler.CreateNurseReport)
	r.Put("/nurse-report/:id", middleware.StaffAuth, handler.UpdateNurseReport)
	r.Delete("/nurse-report/:id", middleware.StaffAuth, handler.DeleteNurseReport)

	// DOCTOR REPORT
	r.Get("/doctor-reports", middleware.StaffAuth, handler.DoctorReportGetAll)
	r.Post("/doctor-report", middleware.StaffAuth, handler.CreateDoctorReport)
	r.Put("/doctor-report/:id", middleware.StaffAuth, handler.UpdateDoctorReport)
	r.Delete("/doctor-report/:id", middleware.StaffAuth, handler.DeleteDoctorReport)

	// DORM
	r.Get("/dorms", middleware.StaffAuth, handler.DormGetAll)
	r.Post("/dorm", middleware.StaffAuth, handler.CreateDorm)
	r.Put("/dorm/:id", middleware.StaffAuth, handler.UpdateDorm)
	r.Delete("/dorm/:id", middleware.StaffAuth, handler.DeleteDorm)

	// MEDICAL HISTORY
	r.Get("/medical-histories", middleware.Auth, handler.GetAllMedicalHistoryByToken)
	r.Post("/medical-history", middleware.StaffAuth, handler.CreateMedicalHistory)

	// REMINDER
	r.Get("/reminders", middleware.Auth, handler.ReminderGetAll)
	r.Post("/reminder", middleware.Auth, handler.CreateReminder)
	r.Put("/reminder/:id", middleware.Auth, handler.UpdateReminder)
	r.Delete("/reminder/:id", middleware.Auth, handler.DeleteReminder)

}
