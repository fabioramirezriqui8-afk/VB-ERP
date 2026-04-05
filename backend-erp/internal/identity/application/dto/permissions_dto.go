package dto

import "time"

type PermissionResponse struct {
	ID          string    `json:"id"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	Module      string    `json:"module"`
	Action      string    `json:"action"`
	CreatedAt   time.Time `json:"created_at"`
}
