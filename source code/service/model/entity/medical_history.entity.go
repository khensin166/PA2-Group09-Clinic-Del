package entity

type MedicalHistory struct {
	ID              uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Indication      string `json:"indication"`
	BodyTemperature string `json:"body_temperature"`
	Medicine        string `json:"medicine"`
	Diagnose        string `json:"diagnose"`
	DoctorID        uint   `json:"doctor_id"`
	Doctor          Staff  `json:"doctor" gorm:"foreignKey:DoctorID"`
	Date            string `json:"date"`
	UserID          uint   `json:"user_id"`
	User            User   `json:"user" gorm:"foreignKey:UserID"`
}

func (m *MedicalHistory) TableName() string {
	return "medical_histories"
}
