package entity

import (
	"gorm.io/gorm"
	"time"
)

type Reminder struct {
<<<<<<< HEAD
	ID         uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	UserID     int            `json:"user_id" form:"user_id"`
	FirstTime  string         `json:"first_time"`
	SecondTime string         `json:"second_time"`
	ThirdTime  string         `json:"third_time"`
	StartDate  string         `json:"start_date"`
	Name       string         `json:"name"`
	Duration   int            `json:"duration"`
	User       User           `json:"user" gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL"`
	CreatedAt  time.Time      `json:"created_at"`
	UpdatedAt  time.Time      `json:"updated_at"`
	DeletedAt  gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

type ReminderResponse struct {
	ID         uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	UserID     int            `json:"user_id" form:"user_id"`
	FirstTime  string         `json:"first_time"`
	SecondTime string         `json:"second_time"`
	ThirdTime  string         `json:"third_time"`
	StartDate  string         `json:"start_date"`
	Name       string         `json:"name"`
	Duration   int            `json:"duration"`
	CreatedAt  time.Time      `json:"created_at"`
	UpdatedAt  time.Time      `json:"updated_at"`
	DeletedAt  gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
=======
	ID        uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	DateTime  string         `json:"date_time"`
	Name      string         `json:"name"`
	Frequency string         `json:"frequency"`
	Duration  string         `json:"duration"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
>>>>>>> main
}

func (r *Reminder) TableName() string {
	return "reminders"
}
