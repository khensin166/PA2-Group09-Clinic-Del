package request

type UserCreateRequest struct {
	Name     string `json:"name" validate:"required"`
	Age      int    `json:"age"`
	Weight   int    `json:"weight"`
	Height   int    `json:"height"`
	Birthday string `json:"birthday"`
	Gender   string `json:"gender" validate:"required"`
	NIK      int    `json:"NIK" validate:"required"`
	Address  string `json:"address" validate:"required"`
	Phone    string `json:"phone" validate:"required"`
	Username string `json:"username" gorm:"unique"`
	Password string `json:"password" validate:"required,min=6"`
}

type UserUpdateRequest struct {
	Name     string `json:"name" validate:"required"`
	Age      int    `json:"age"`
	Weight   int    `json:"weight"`
	Height   int    `json:"height"`
	Birthday string `json:"birthday"`
	Gender   string `json:"gender" validate:"required"`
	NIK      int    `json:"NIK" validate:"required"`
	Address  string `json:"address" validate:"required"`
	Phone    string `json:"phone" validate:"required"`
	Username string `json:"username" gorm:"unique"`
	Password string `json:"password" validate:"required,min=6"`
}
