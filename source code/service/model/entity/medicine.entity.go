package entity

type Medicine struct {
	ID             uint         `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name           string       `json:"name"`
	Amount         int          `json:"amount"`
	Expired        string       `json:"expired"`
	DoctorReportID uint         `json:"doctor_report_id"`
	DoctorReport   DoctorReport `json:"doctor_report" gorm:"foreignKey:DoctorReportID"`
}

func (m *Medicine) TableName() string {
	return "medicines"
}