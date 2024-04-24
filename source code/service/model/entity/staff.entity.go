package entity

import (
	"gorm.io/gorm"
	"time"
)

type Role string

const (
	RoleSuster Role = "suster"
	RoleDokter Role = "dokter"
)

type Staff struct {
	ID           uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name         string         `json:"name"`
	Age          int            `json:"age"`
	Weight       int            `json:"weight"`
	Height       int            `json:"height"`
	NIP          int            `json:"NIP"`
	Birthday     string         `json:"birthday"`
	Gender       string         `json:"gender"`
	Address      string         `json:"address"`
	Phone        string         `json:"phone"`
	Username     string         `json:"username" gorm:"unique"`
	Password     string         `json:"password" gorm:"column:password"`
	Role         string         `json:"role"`
	Appointments []*Appointment `json:"appointments" gorm:"foreignKey:ApprovedID"`
	CreatedAt    time.Time      `json:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at"`
	DeletedAt    gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

func (s *Staff) TableName() string {
	return "staffs"
}
