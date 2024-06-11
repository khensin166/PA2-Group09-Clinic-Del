package entity

import (
	"gorm.io/gorm"
	"time"
)

type Staff struct {
	ID             *uint          `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name           string         `json:"name"`
	Age            int            `json:"age"`
	Weight         int            `json:"weight"`
	Height         int            `json:"height"`
	NIP            int            `json:"NIP"`
	Birthday       string         `json:"birthday"`
	Gender         string         `json:"gender"`
	Address        string         `json:"address"`
	Phone          string         `json:"phone"`
	Username       string         `json:"username" gorm:"unique"`
	Password       string         `json:"password" gorm:"column:password"`
	Role           int            `json:"role"`
	ProfilePicture *string        `json:"profilePicture"`
	Appointments   *Appointment   `json:"appointments" gorm:"foreignKey:ApprovedID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	NurseReports   []NurseReport  `json:"nurse_reports" gorm:"foreignKey:StaffNurseID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	DoctorReport   []DoctorReport `json:"doctorReport" gorm:"foreignKey:StaffDoctorID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CreatedAt      time.Time      `json:"created_at"`
	UpdatedAt      time.Time      `json:"updated_at"`
	DeletedAt      gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

type StaffResponse struct {
	ID       uint   `json:"id" form:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name     string `json:"name" form:"name"`
	Age      int    `json:"age" form:"age"`
	Weight   int    `json:"weight" form:"weight"`
	Height   int    `json:"height" form:"height"`
	NIP      int    `json:"NIP" form:"NIP"`
	Birthday string `json:"birthday" form:"birthday"`
	Gender   string `json:"gender" form:"gender"`
	Address  string `json:"address" form:"address"`
	Phone    string `json:"phone" form:"phone"`
	Username string `json:"username" gorm:"unique"`
	Password string `json:"password" gorm:"column:password"`
	Role     int    `json:"role"`
}

func (StaffResponse) TableName() string {
	return "staffs"
}
