package entity

import (
	"gorm.io/gorm"
	"time"
)

type Reminder struct {
	ID        uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	DateTime  string         `json:"date_time"`
	Name      string         `json:"name"`
	Frequency string         `json:"frequency"`
	Duration  string         `json:"duration"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

func (r *Reminder) TableName() string {
	return "reminders"
}
