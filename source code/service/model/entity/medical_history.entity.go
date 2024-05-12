package entity

type MedicalHistory struct {
	ID             uint         `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	DoctorReport   DoctorReport `json:"doctorReport" gorm:"foreignKey:DoctorReportID"`
	DoctorReportID uint         `json:"-"`
	User           User         `json:"user" gorm:"foreignKey:UserID"`
	UserID         uint         `json:"-"`
}

func (m *MedicalHistory) TableName() string {
	return "medical_histories"
}
