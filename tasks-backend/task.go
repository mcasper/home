package tasks_backend

import (
	"time"
)

type Task struct {
	ID        uint       `json:"id" gorm:"primary_key"`
	Text      string     `json:"text"`
	Complete  bool       `json:"complete"`
	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
	DeletedAt *time.Time `json:"deleted_at"`
}
