package entity

import (
	"gorm.io/gorm"
	"time"
)

type NurseReport struct {
	ID                uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Temperature       string         `json:"temperature"`
	Systole           string         `json:"systole"`
	Diastole          string         `json:"diastole"`
	Pulse             string         `json:"pulse"`
	Respiration       string         `json:"respiration"`
	SizeCircumference int            `json:"SizeCircumference"`
	Weight            int            `json:"weight"`
	Allergy           string         `json:"allergy"`
	IsChecked         *bool          `json:"is_checked"`
	StaffNurseID      uint           `json:"staff_nurse_id"`
	PatientID         uint           `json:"patient_id"`
	Patient           User           `json:"patient" gorm:"foreignKey:PatientID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	StaffNurse        Staff          `json:"staff" gorm:"foreignKey:StaffNurseID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CreatedAt         time.Time      `json:"created_at"`
	UpdatedAt         time.Time      `json:"updated_at"`
	DeletedAt         gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

type NurseReportResponse struct {
	ID                uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Temperature       string         `json:"temperature"`
	Systole           string         `json:"systole"`
	Diastole          string         `json:"diastole"`
	Pulse             string         `json:"pulse"`
	SaturationOxygen  string         `json:"saturation_oxygen"`
	Respiration       string         `json:"respiration"`
	SizeCircumference int            `json:"SizeCircumference"`
	Allergy           string         `json:"allergy"`
	StaffNurseID      int            `json:"staff_id"`
	PatientID         int            `json:"patient_id"`
	IsChecked         *bool          `json:"is_checked"`
	Patient           User           `json:"patient" gorm:"foreignKey:PatientID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	StaffNurse        Staff          `json:"staff" gorm:"foreignKey:StaffNurseID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CreatedAt         time.Time      `json:"created_at"`
	UpdatedAt         time.Time      `json:"updated_at"`
	DeletedAt         gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

type NurseReportResponseUpdate struct {
	ID                uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Temperature       string         `json:"temperature"`
	Systole           string         `json:"systole"`
	Diastole          string         `json:"diastole"`
	Pulse             string         `json:"pulse"`
	SaturationOxygen  string         `json:"saturation_oxygen"`
	Respiration       string         `json:"respiration"`
	SizeCircumference int            `json:"SizeCircumference"`
	IsChecked         *bool          `json:"is_checked"`
	Allergy           string         `json:"allergy"`
	CreatedAt         time.Time      `json:"created_at"`
	UpdatedAt         time.Time      `json:"updated_at"`
	DeletedAt         gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

func (NurseReportResponse) TableName() string {
	return "nurse_reports"
}
