package entity

type DoctorReport struct {
	ID            uint        `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Disease       string      `json:"disease"`
	NurseReportID uint        `json:"nurse_report_id"`
	NurseReport   NurseReport `json:"nurse_report" gorm:"foreignKey:NurseReportID"`
	MedicineID    uint        `json:"medicine_id"`
	Medicine      Medicine    `json:"medicine" gorm:"foreignKey:MedicineID"`
}

func (d *DoctorReport) TableName() string {
	return "doctor_reports"
}
