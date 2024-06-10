package entity

import (
	"gorm.io/gorm"
	"time"
)

// Gallery entity with a one-to-one relationship with ClinicInformation
type Gallery struct {
	ID        uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Picture1  string         `json:"picture_1"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

func (*Gallery) TableName() string {
	return "galleries"
}
