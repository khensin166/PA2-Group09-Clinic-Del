package entity

import (
	"gorm.io/gorm"
	"time"
)

type Staff struct {
	ID        uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name      string         `json:"name"`
	Age       int            `json:"age"`
	Weight    int            `json:"weight"`
	Height    int            `json:"height"`
	NIP       int            `json:"NIP"`
	Birthday  string         `json:"birthday"`
	Gender    string         `json:"gender"`
	Address   string         `json:"address"`
	Phone     string         `json:"phone"`
	Username  string         `json:"username" gorm:"unique"`
	Password  string         `json:"password" gorm:"column:password"`
	Role      string         `json:"role"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

type StaffResponse struct {
	ID   int    `json:"id" form:"id" gorm:"primaryKey"`
	Name string `json:"name" form:"name"`
}

func (StaffResponse) TableName() string {
	return "users" //return nama tablenya
}
