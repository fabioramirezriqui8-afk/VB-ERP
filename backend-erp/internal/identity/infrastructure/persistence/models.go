package persistence

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type permissionModel struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey"`
	Name        string    `gorm:"uniqueIndex;not null"`
	Description string
	Module      string `gorm:"not null"`
	Action      string `gorm:"not null"`
	CreatedAt   time.Time
}

func (permissionModel) TableName() string { return "permissions" }

type roleModel struct {
	ID          uuid.UUID         `gorm:"type:uuid;primaryKey"`
	Name        string            `gorm:"uniqueIndex;not null"`
	Description string
	Permissions []permissionModel `gorm:"many2many:role_permissions;"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

func (roleModel) TableName() string { return "roles" }

type userModel struct {
	ID        uuid.UUID      `gorm:"type:uuid;primaryKey"`
	Name      string         `gorm:"not null"`
	Email     string         `gorm:"uniqueIndex;not null"`
	Password  string         `gorm:"not null"`
	Roles     []roleModel    `gorm:"many2many:user_roles;"`
	Active    bool           `gorm:"default:true"`
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
}

func (userModel) TableName() string { return "users" }

type refreshTokenModel struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey"`
	UserID    uuid.UUID `gorm:"type:uuid;index;not null"`
	Token     string    `gorm:"uniqueIndex;not null"`
	ExpiresAt time.Time `gorm:"not null"`
	Revoked   bool      `gorm:"default:false"`
	CreatedAt time.Time
}

func (refreshTokenModel) TableName() string { return "refresh_tokens" }
