package persistence

import (
	"context"
	"errors"

	domain "github.com/vctr/vb-erp/internal/identity/domain"
	"gorm.io/gorm"
)

type permissionRepository struct{ db *gorm.DB }

func NewPermissionRepository(db *gorm.DB) domain.PermissionRepository {
	return &permissionRepository{db: db}
}

func (r *permissionRepository) FindByName(ctx context.Context, name string) (*domain.Permission, error) {
	var m permissionModel
	err := r.db.WithContext(ctx).Where("name = ?", name).First(&m).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return toPermissionEntity(&m), nil
}

func (r *permissionRepository) List(ctx context.Context) ([]*domain.Permission, error) {
	var models []permissionModel
	err := r.db.WithContext(ctx).Find(&models).Error
	if err != nil {
		return nil, err
	}

	perms := make([]*domain.Permission, len(models))
	for i, m := range models {
		m := m
		perms[i] = toPermissionEntity(&m)
	}
	return perms, nil
}

func toPermissionEntity(m *permissionModel) *domain.Permission {
	return &domain.Permission{
		ID:          m.ID,
		Name:        m.Name,
		Description: m.Description,
		Module:      m.Module,
		Action:      m.Action,
		CreatedAt:   m.CreatedAt,
	}
}
