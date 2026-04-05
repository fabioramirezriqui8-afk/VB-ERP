package domain

import (
	"context"

	"github.com/google/uuid"
	sharedDomain "github.com/vctr/vb-erp/internal/shared/domain"
)

type UserRepository interface {
	Create(ctx context.Context, user *User) error
	FindByID(ctx context.Context, id uuid.UUID) (*User, error)
	FindByEmail(ctx context.Context, email sharedDomain.Email) (*User, error)
	Update(ctx context.Context, user *User) error
	Delete(ctx context.Context, id uuid.UUID) error
	List(ctx context.Context, page sharedDomain.PageRequest) ([]*User, int64, error)
	AssignRole(ctx context.Context, userID, roleID uuid.UUID) error
	RemoveRole(ctx context.Context, userID, roleID uuid.UUID) error
}

type RoleRepository interface {
	Create(ctx context.Context, role *Role) error
	FindByID(ctx context.Context, id uuid.UUID) (*Role, error)
	FindByName(ctx context.Context, name string) (*Role, error)
	List(ctx context.Context) ([]*Role, error)
	AssignPermission(ctx context.Context, roleID, permissionID uuid.UUID) error
	RemovePermission(ctx context.Context, roleID, permissionID uuid.UUID) error
}

type PermissionRepository interface {
	FindByName(ctx context.Context, name string) (*Permission, error)
	List(ctx context.Context) ([]*Permission, error)
}

type RefreshTokenRepository interface {
	Save(ctx context.Context, token *RefreshToken) error
	FindByToken(ctx context.Context, token string) (*RefreshToken, error)
	RevokeByUserID(ctx context.Context, userID uuid.UUID) error
	Revoke(ctx context.Context, token string) error
}
