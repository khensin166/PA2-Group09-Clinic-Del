package entity

type Medicine struct {
	ID      uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name    string `json:"name"`
	Amount  int    `json:"amount"`
	Expired string `json:"expired"`
	//	MEDICINE PICTURE
}

func (m *Medicine) TableName() string {
	return "medicines"
}
