package entity

import (
	"gorm.io/gorm"
	"time"
)

// properti ketika kita ingin memanggil/mencocokan data dari tabel user.
// contoh jika User.Name berarti memanggil name yang ada di table user.
type User struct {
	ID        uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name      string         `json:"name"`
	Age       int            `json:"age"`
	Weight    int            `json:"weight"`
	Height    int            `json:"height"`
	NIK       int            `json:"nik"`
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

// merepresentasikan data apa aja yang akan di dapatkan/dikirmkan melalui api
type UserResponse struct {
	ID   int    `json:"id" form:"id" gorm:"primaryKey"`
	Name string `json:"name" form:"name"`
}

func (UserResponse) TableName() string {
	return "users" //return nama tablenya
}
