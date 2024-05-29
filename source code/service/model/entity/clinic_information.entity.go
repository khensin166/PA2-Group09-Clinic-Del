package entity

import (
	"gorm.io/gorm"
	"time"
)

type ClinicInformation struct {
	ID             uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	ProfilePicture *string        `json:"profilePicture"`
	Gallery        []Gallery      `json:"-" gorm:"foreignKey:RequestedID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Requested      User           `json:"requested" gorm:"foreignKey:RequestedID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	RequestedID    uint           `json:"requested_id" form:"requested_id"`
	CreatedAt      time.Time      `json:"created_at"`
	UpdatedAt      time.Time      `json:"updated_at"`
	DeletedAt      gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

func (*ClinicInformation) TableName() string {
	return "users"
}
