package migration

import (
	"fmt"
	"github.com/khensin166/PA2-Kel9/database"
	"github.com/khensin166/PA2-Kel9/model/entity"
	"log"
)

func Migration() {
	//database.DB merupakan variable yang di assign di database.go
	err := database.DB.AutoMigrate(
		&entity.Appointment{},
		&entity.DoctorReport{},
		&entity.MedicalHistory{},
		&entity.Medicine{},
		&entity.NurseReport{},
		&entity.Remainder{},
		&entity.User{},
		&entity.Staff{},
	)

	if err != nil {
		log.Println(err)
	}
	fmt.Println("Database Migrated")
}
