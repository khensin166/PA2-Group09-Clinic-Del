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
	StaffNurseID           int    `json:"staff_id"`
	PatientID              int    `json:"patient_id"`
	Patient                User   `json:"patient" gorm:"foreignKey:PatientID"`
	StaffNurse             Staff  `json:"staff" gorm:"foreignKey:StaffNurseID"`
}

type NurseReportResponse struct {
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
	StaffNurseID           int    `json:"staff_id"`
	PatientID              int    `json:"patient_id"`
}

type NurseReportResponseUpdate struct {
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
}

func (NurseReportResponse) TableName() string {
	return "nurse_reports"
}
