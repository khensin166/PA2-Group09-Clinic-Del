package entity

type Dorm struct {
	ID     uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name   string `json:"name"`
	Status string `json:"status"`
}

var allowedDormNames = map[string]bool{
	"Pniel":     true,
	"Jati":      true,
	"Rusun 4":   true,
	"Nazareth":  true,
	"Silo":      true,
	"Kapernaum": true,
	"Mambri":    true,
}

func (m *Dorm) TableName() string {
	return "dorms"
}

//if _, ok := allowedDormNames[dormName]; !ok {
//		return nil, errors.New("Nama asrama tidak diizinkan")
//	}
//
//	newDorm := &Dorm{
//		Name:   dormName,
//		Status: dormStatus,
//	}
