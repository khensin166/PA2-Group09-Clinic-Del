package entity

type Medicine struct {
	ID      uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name    string         `json:"name"`
	Amount  int            `json:"amount"`
	Expired string         `json:"expired"`
	Reports []DoctorReport `gorm:"many2many:medicine_doctor_report;"`
	// medicine picture

}

func (m *Medicine) TableName() string {
	return "medicines"
}
