package entity

import (
	"gorm.io/gorm"
	"time"
)

type Gallery struct {
	ID          uint              `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Picture1    *string           `json:"picture_1"`
	RequestedID uint              `json:"requested_id"`
	Requested   ClinicInformation `json:"requested" gorm:"foreignKey:RequestedID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CreatedAt   time.Time         `json:"created_at"`
	UpdatedAt   time.Time         `json:"updated_at"`
	DeletedAt   gorm.DeletedAt    `json:"-" gorm:"index,column:deleted_at"`
}

func (*Gallery) TableName() string {
	return "galleries"
}
