package entity

type Medicine struct {
	ID      uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name    string `json:"name"`
	Amount  int    `json:"amount"`
	Expired string `json:"expired"`
	StaffID uint   `json:"staff_id"`
	Staff   Staff  `json:"staff" gorm:"foreignKey:StaffID"`
}

func (m *Medicine) TableName() string {
	return "medicines"
}
