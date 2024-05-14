package entity

type DoctorReport struct {
	ID            uint        `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	NurseReportID uint        `json:"nurse_report_id"`
	StaffDoctorID uint        `json:"staff_doctor_id"`
	Disease       string      `json:"disease"`
	Amount        int         `json:"amount"`
	NurseReport   NurseReport `json:"nurse_report" gorm:"foreignKey:NurseReportID"`
	StaffDoctor   Staff       `json:"staffDoctor" gorm:"foreignKey:StaffDoctorID"`
	Medicines     []Medicine  `gorm:"many2many:medicine_doctor_report;"`
}

type DoctorReportResponse struct {
	ID            uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Disease       string `json:"disease"`
	NurseReportID uint   `json:"nurse_report_id"`
	MedicineID    uint   `json:"medicine_id"`
	StaffDoctorID uint   `json:"staff_doctor_id"`
}

func (d *DoctorReport) TableName() string {
	return "doctor_reports"
}
