package entity

import (
	"gorm.io/gorm"
	"time"
)

type RoleUser string

const (
	RoleSiswa     RoleUser = "siswa"
	RoleMahasiswa RoleUser = "mahasiswa"
	RoleStaff     RoleUser = "staff"
	RoleDosen     RoleUser = "dosen"
)

// properti ketika kita ingin memanggil/mencocokan data dari tabel user.
// contoh jika User.Name berarti memanggil name yang ada di table user.
type User struct {
	ID             uint             `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name           string           `json:"name"`
	Age            int              `json:"age"`
	Weight         int              `json:"weight"`
	Height         int              `json:"height"`
	NIK            int              `json:"nik"`
	Birthday       string           `json:"birthday"`
	Gender         string           `json:"gender"`
	Address        string           `json:"address"`
	Phone          string           `json:"phone"`
	Username       string           `json:"username" gorm:"unique"`
	Password       string           `json:"password" gorm:"column:password"`
	Appointments   []*Appointment   `json:"appointments" gorm:"foreignKey:RequestedID"`
	Role           *RoleUser        `json:"role"`
	MedicalHistory []MedicalHistory `json:"medical_histories"`
	CreatedAt      time.Time        `json:"created_at"`
	UpdatedAt      time.Time        `json:"updated_at"`
	DeletedAt      gorm.DeletedAt   `json:"-" gorm:"index,column:deleted_at"`
}

func (U *User) TableName() string {
	return "user"
}
