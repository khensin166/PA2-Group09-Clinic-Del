package entity

type NurseReport struct {
	ID                     uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Temperature            string `json:"temperature"`
	Systole                string `json:"systole"`
	Diastole               string `json:"diastole"`
	Pulse                  string `json:"pulse"`
	OxygenSaturation       string `json:"oxygen_saturation"`
	Respiration            string `json:"respiration"`
	Height                 int    `json:"height"`
	Weight                 int    `json:"weight"`
	AbdominalCircumference int    `json:"abdominal_circumference"`
	Allergy                string `json:"allergy"`
	StaffID                uint   `json:"staff_id"`
	Staff                  Staff  `json:"staff" gorm:"foreignKey:StaffID"`
}

func (n *NurseReport) TableName() string {
	return "nurse_report"
}
