package entity

import (
	"gorm.io/gorm"
	"time"
)

type ClinicInformation struct {
	ID          uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	GalleryID   uint           `json:"gallery_id"` // Foreign key
	Description string         `json:"description"`
	Gallery     Gallery        `json:"gallery" gorm:"foreignKey:GalleryID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

type ClinicInformationResponse struct {
	ID          uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Gallery     Gallery        `json:"gallery"`
	Description string         `json:"description"`
	GalleryID   uint           `json:"gallery_id"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

func (*ClinicInformation) TableName() string {
	return "clinic_information"
}
