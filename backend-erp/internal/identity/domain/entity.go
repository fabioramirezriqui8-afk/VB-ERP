package domain

import (
	"time"

	"github.com/google/uuid"
	sharedDomain "github.com/vctr/vb-erp/internal/shared/domain"
)

// ── Permission ───────────────────────────────────────────────────────────────

type Permission struct {
	ID          uuid.UUID
	Name        string // "inventory:products:read"
	Description string
	Module      string // "inventory"
	Action      string // "read"
	CreatedAt   time.Time
}

// ── Role ─────────────────────────────────────────────────────────────────────

type Role struct {
	ID          uuid.UUID
	Name        string
	Description string
	Permissions []Permission
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

func (r *Role) HasPermission(name string) bool {
	for _, p := range r.Permissions {
		if p.Name == name {
			return true
		}
	}
	return false
}

// ── User (Aggregate Root) ─────────────────────────────────────────────────────

type User struct {
	sharedDomain.AggregateRoot
	ID        uuid.UUID
	Name      string
	Email     sharedDomain.Email
	Password  string
	Roles     []Role
	Active    bool
	CreatedAt time.Time
	UpdatedAt time.Time
}

func NewUser(name string, email sharedDomain.Email, hashedPassword string) *User {
	return &User{
		ID:        uuid.New(),
		Name:      name,
		Email:     email,
		Password:  hashedPassword,
		Active:    true,
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}
}

// HasPermission verifica si el usuario tiene un permiso a través de cualquiera de sus roles
func (u *User) HasPermission(permission string) bool {
	for _, r := range u.Roles {
		if r.HasPermission(permission) {
			return true
		}
	}
	return false
}

// HasRole verifica si el usuario tiene un rol específico
func (u *User) HasRole(roleName string) bool {
	for _, r := range u.Roles {
		if r.Name == roleName {
			return true
		}
	}
	return false
}

// RoleNames retorna los nombres de los roles del usuario
func (u *User) RoleNames() []string {
	names := make([]string, len(u.Roles))
	for i, r := range u.Roles {
		names[i] = r.Name
	}
	return names
}

// ── RefreshToken ─────────────────────────────────────────────────────────────

type RefreshToken struct {
	ID        uuid.UUID
	UserID    uuid.UUID
	Token     string
	ExpiresAt time.Time
	Revoked   bool
	CreatedAt time.Time
}

func (t *RefreshToken) IsValid() bool {
	return !t.Revoked && time.Now().Before(t.ExpiresAt)
}
