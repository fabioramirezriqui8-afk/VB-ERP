package persistence

import (
	"context"
	"errors"

	"github.com/google/uuid"
	domain "github.com/vctr/vb-erp/internal/identity/domain"
	"gorm.io/gorm"
)

type roleRepository struct{ db *gorm.DB }

func NewRoleRepository(db *gorm.DB) domain.RoleRepository {
	return &roleRepository{db: db}
}

func (r *roleRepository) Create(ctx context.Context, role *domain.Role) error {
	return r.db.WithContext(ctx).Create(fromRoleEntity(role)).Error
}

func (r *roleRepository) FindByID(ctx context.Context, id uuid.UUID) (*domain.Role, error) {
	var m roleModel
	err := r.db.WithContext(ctx).Preload("Permissions").Where("id = ?", id).First(&m).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	role := toRoleEntity(&m)
	return &role, nil
}

func (r *roleRepository) FindByName(ctx context.Context, name string) (*domain.Role, error) {
	var m roleModel
	err := r.db.WithContext(ctx).Preload("Permissions").Where("name = ?", name).First(&m).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	role := toRoleEntity(&m)
	return &role, nil
}

func (r *roleRepository) List(ctx context.Context) ([]*domain.Role, error) {
	var models []roleModel
	err := r.db.WithContext(ctx).Preload("Permissions").Find(&models).Error
	if err != nil {
		return nil, err
	}

	roles := make([]*domain.Role, len(models))
	for i, m := range models {
		m := m
		role := toRoleEntity(&m)
		roles[i] = &role
	}
	return roles, nil
}

func (r *roleRepository) AssignPermission(ctx context.Context, roleID, permissionID uuid.UUID) error {
	return r.db.WithContext(ctx).Exec(
		"INSERT INTO role_permissions (role_id, permission_id) VALUES (?, ?) ON CONFLICT DO NOTHING",
		roleID, permissionID,
	).Error
}

func (r *roleRepository) RemovePermission(ctx context.Context, roleID, permissionID uuid.UUID) error {
	return r.db.WithContext(ctx).Exec(
		"DELETE FROM role_permissions WHERE role_id = ? AND permission_id = ?",
		roleID, permissionID,
	).Error
}

func fromRoleEntity(r *domain.Role) *roleModel {
	return &roleModel{
		ID:          r.ID,
		Name:        r.Name,
		Description: r.Description,
	}
}
