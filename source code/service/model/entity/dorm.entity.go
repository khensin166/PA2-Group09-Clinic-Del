package entity

type Dorm struct {
	ID     uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name   string `json:"name"`
	Status string `json:"status"`
}

func (m *Dorm) TableName() string {
	return "dorms"
}
