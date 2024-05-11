package entity

type Appointment struct {
	ID          uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Date        string `json:"date" form:"date"`
	Time        string `json:"time" form:"time"`
	Complaint   string `json:"complaint" form:"complaint"`
	ApprovedID  uint   `json:"approved_id"`
	RequestedID uint   `json:"requested_id"`
	Approved    Staff  `json:"approved" gorm:"foreignKey:ApprovedID"`
	Requested   User   `json:"requested" gorm:"foreignKey:RequestedID"`
}

type AppointmentResponse struct {
	ID          uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Date        string `json:"date" form:"date"`
	Time        string `json:"time" form:"time"`
	Complaint   string `json:"complaint" form:"complaint"`
	ApprovedID  *uint  `json:"approved_id" form:"approved_id"` // Changed to *uint
	RequestedID uint   `json:"requested_id" form:"requested_id"`
}

type AppointmentUpdate struct {
	Date        string `json:"date" form:"date"`
	Time        string `json:"time" form:"time"`
	Complaint   string `json:"complaint" form:"complaint"`
	ApprovedID  *uint  `json:"approved_id" form:"approved_id"` // Changed to *uint
	RequestedID *uint  `json:"requested_id" form:"requested_id"`
}

func (AppointmentResponse) TableName() string {
	return "appointments"
}
