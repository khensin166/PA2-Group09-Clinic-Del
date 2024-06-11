package entity

import (
	"gorm.io/gorm"
	"time"
)

type User struct {
	ID                 uint             `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name               string           `json:"name"`
	Age                int              `json:"age"`
	Weight             int              `json:"weight"`
	Height             int              `json:"height"`
	NIK                int              `json:"nik"`
	Birthday           string           `json:"birthday"`
	Gender             string           `json:"gender"`
	Address            string           `json:"address"`
	Phone              string           `json:"phone"`
	RegistrationNumber string           `json:"registration_number"`
	Username           string           `json:"username" gorm:"unique"`
	Password           string           `json:"password" gorm:"column:password"`
	Role               int              `json:"role"`
	DormID             uint             `json:"dormID"`
	Dorm               *Dorm            `json:"dorm" gorm:"foreignKey:DormID"`
	ProfilePicture     *string          `json:"profilePicture"`
	Appointments       []Appointment    `json:"-" gorm:"foreignKey:RequestedID;;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	MedicalHistory     []MedicalHistory `json:"-" gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	NurseReport        *NurseReport     `json:"-" gorm:"foreignKey:PatientID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CreatedAt          time.Time        `json:"created_at"`
	UpdatedAt          time.Time        `json:"updated_at"`
	DeletedAt          gorm.DeletedAt   `json:"-" gorm:"index,column:deleted_at"`
}

type UserResponse struct {
	ID             uint    `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	DormID         uint    `json:"dormID"`
	Name           string  `json:"name"`
	Age            int     `json:"age"`
	Weight         int     `json:"weight"`
	Height         int     `json:"height"`
	NIK            int     `json:"nik"`
	Birthday       string  `json:"birthday"`
	Gender         string  `json:"gender"`
	Address        string  `json:"address"`
	Phone          string  `json:"phone"`
	Username       string  `json:"username" gorm:"unique"`
	Password       string  `json:"password" gorm:"column:password"`
	Role           int     `json:"role"`
	ProfilePicture *string `json:"profilePicture"`
}

type UserProfileResponse struct {
	Name           string  `json:"name"`
	ID             uint    `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Username       string  `json:"username" gorm:"unique"`
	ProfilePicture *string `json:"profilePicture"`
}

func (UserResponse) TableName() string {
	return "users"
}
