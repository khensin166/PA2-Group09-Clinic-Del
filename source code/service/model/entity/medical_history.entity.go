package entity

type MedicalHistory struct {
	ID             uint         `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	UserID         uint         `json:"UserID"`
	DoctorReportID uint         `json:"DoctorReportID"`
	DoctorReport   DoctorReport `json:"doctorReport" gorm:"foreignKey:DoctorReportID"`
	User           User         `json:"user" gorm:"foreignKey:UserID"`
}

type MedicalHistoryResponse struct {
	UserID         uint `json:"UserID"`
	DoctorReportID uint `json:"DoctorReportID"`
}

func (m *MedicalHistory) TableName() string {
	return "medical_histories"
}
