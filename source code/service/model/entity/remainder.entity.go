package entity

type Remainder struct {
	ID         uint     `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Date       string   `json:"date"`
	Time       string   `json:"time"`
	Frequency  string   `json:"frequency"`
	Duration   string   `json:"duration"`
	MedicineID uint     `json:"medicine_id"`
	Medicine   Medicine `json:"medicine" gorm:"foreignKey:MedicineID"`
}

func (r *Remainder) TableName() string {
	return "remainders"
}
