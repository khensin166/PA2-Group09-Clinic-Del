package entity

type Appointment struct {
	ID          uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Date        string `json:"date"`
	Time        string `json:"time"`
	Complaint   string `json:"complaint"`
	Status      bool   `json:"status"`
	Approved    *Staff `json:"approved" gorm:"foreignKey:ApprovedID"`
	ApprovedID  uint   `json:"approved_id"`
	Requested   *User  `json:"requested" gorm:"foreignKey:RequestedID"`
	RequestedID uint   `json:"requested_id"`
}

func (a *Appointment) TableName() string {
	return "appointments"
}
