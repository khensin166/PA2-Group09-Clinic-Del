package entity

import (
	"gorm.io/gorm"
	"time"
)

type DoctorReport struct {
	ID            uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	StaffDoctorID *uint          `json:"staff_doctor_id"`
	Disease       string         `json:"disease"`
	Amount        int            `json:"amount"`
	NurseReportID uint           `json:"nurse_report_id"`
	MedicineID    uint           `json:"medicine_id"`
	NurseReport   NurseReport    `json:"nurse_report" gorm:"foreignKey:NurseReportID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	StaffDoctor   Staff          `json:"staff_doctor" gorm:"foreignKey:StaffDoctorID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Medicine      Medicine       `json:"medicine" gorm:"foreignKey:MedicineID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CreatedAt     time.Time      `json:"created_at"`
	UpdatedAt     time.Time      `json:"updated_at"`
	DeletedAt     gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

type DoctorReportResponse struct {
	ID            uint    `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Disease       *string `json:"disease"`
	Amount        *int    `json:"amount"`
	NurseReportID *uint   `json:"nurse_report_id"`
	MedicineID    uint    `json:"medicine_id"`
	StaffDoctorID uint    `json:"staff_doctor_id"`
}

type ReportRequest struct {
	StaffDoctorID *uint    `json:"staff_doctor_id"`
	Disease       *string  `json:"disease"`
	NurseReportID *uint    `json:"nurse_report_id"`
	Medicines     Medicine `json:"medicines"`
	Amount        *int     `json:"amount"`
}

func (d *DoctorReport) TableName() string {
	return "doctor_reports"
}
