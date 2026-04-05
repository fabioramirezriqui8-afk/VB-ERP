package persistence

import (
	"context"
	"errors"

	"github.com/google/uuid"
	domain "github.com/vctr/vb-erp/internal/identity/domain"
	sharedDomain "github.com/vctr/vb-erp/internal/shared/domain"
	"gorm.io/gorm"
)

type userRepository struct{ db *gorm.DB }

func NewUserRepository(db *gorm.DB) domain.UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) Create(ctx context.Context, user *domain.User) error {
	return r.db.WithContext(ctx).Create(fromUserEntity(user)).Error
}

func (r *userRepository) FindByID(ctx context.Context, id uuid.UUID) (*domain.User, error) {
	var m userModel
	err := r.db.WithContext(ctx).
		Preload("Roles.Permissions").
		Where("id = ? AND active = true AND deleted_at IS NULL", id).
		First(&m).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return toUserEntity(&m), nil
}

func (r *userRepository) FindByEmail(ctx context.Context, email sharedDomain.Email) (*domain.User, error) {
	var m userModel
	err := r.db.WithContext(ctx).
		Preload("Roles.Permissions").
		Where("email = ? AND active = true AND deleted_at IS NULL", email.String()).
		First(&m).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return toUserEntity(&m), nil
}

func (r *userRepository) Update(ctx context.Context, user *domain.User) error {
	return r.db.WithContext(ctx).Save(fromUserEntity(user)).Error
}

func (r *userRepository) Delete(ctx context.Context, id uuid.UUID) error {
	return r.db.WithContext(ctx).Delete(&userModel{}, "id = ?", id).Error
}

func (r *userRepository) List(ctx context.Context, page sharedDomain.PageRequest) ([]*domain.User, int64, error) {
	var models []userModel
	var total int64
	page.Normalize()

	r.db.WithContext(ctx).Model(&userModel{}).Where("deleted_at IS NULL").Count(&total)
	err := r.db.WithContext(ctx).
		Preload("Roles.Permissions").
		Where("deleted_at IS NULL").
		Offset(page.Offset()).Limit(page.Limit).
		Find(&models).Error
	if err != nil {
		return nil, 0, err
	}

	users := make([]*domain.User, len(models))
	for i, m := range models {
		m := m
		users[i] = toUserEntity(&m)
	}
	return users, total, nil
}

func (r *userRepository) AssignRole(ctx context.Context, userID, roleID uuid.UUID) error {
	return r.db.WithContext(ctx).Exec(
		"INSERT INTO user_roles (user_id, role_id) VALUES (?, ?) ON CONFLICT DO NOTHING",
		userID, roleID,
	).Error
}

func (r *userRepository) RemoveRole(ctx context.Context, userID, roleID uuid.UUID) error {
	return r.db.WithContext(ctx).Exec(
		"DELETE FROM user_roles WHERE user_id = ? AND role_id = ?",
		userID, roleID,
	).Error
}

// ── mappers ───────────────────────────────────────────────────────────────────

func toUserEntity(m *userModel) *domain.User {
	email, _ := sharedDomain.NewEmail(m.Email)
	roles := make([]domain.Role, len(m.Roles))
	for i, r := range m.Roles {
		roles[i] = toRoleEntity(&r)
	}
	return &domain.User{
		ID:        m.ID,
		Name:      m.Name,
		Email:     email,
		Password:  m.Password,
		Roles:     roles,
		Active:    m.Active,
		CreatedAt: m.CreatedAt,
		UpdatedAt: m.UpdatedAt,
	}
}

func fromUserEntity(u *domain.User) *userModel {
	return &userModel{
		ID:       u.ID,
		Name:     u.Name,
		Email:    u.Email.String(),
		Password: u.Password,
		Active:   u.Active,
	}
}

func toRoleEntity(m *roleModel) domain.Role {
	perms := make([]domain.Permission, len(m.Permissions))
	for i, p := range m.Permissions {
		perms[i] = domain.Permission{
			ID:          p.ID,
			Name:        p.Name,
			Description: p.Description,
			Module:      p.Module,
			Action:      p.Action,
			CreatedAt:   p.CreatedAt,
		}
	}
	return domain.Role{
		ID:          m.ID,
		Name:        m.Name,
		Description: m.Description,
		Permissions: perms,
		CreatedAt:   m.CreatedAt,
		UpdatedAt:   m.UpdatedAt,
	}
}
