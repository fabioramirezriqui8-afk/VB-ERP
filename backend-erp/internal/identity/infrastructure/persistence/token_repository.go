package persistence

import (
	"context"
	"errors"

	"github.com/google/uuid"
	domain "github.com/vctr/vb-erp/internal/identity/domain"
	"gorm.io/gorm"
)

type refreshTokenRepository struct{ db *gorm.DB }

func NewRefreshTokenRepository(db *gorm.DB) domain.RefreshTokenRepository {
	return &refreshTokenRepository{db: db}
}

func (r *refreshTokenRepository) Save(ctx context.Context, token *domain.RefreshToken) error {
	m := &refreshTokenModel{
		ID:        token.ID,
		UserID:    token.UserID,
		Token:     token.Token,
		ExpiresAt: token.ExpiresAt,
		Revoked:   token.Revoked,
	}
	return r.db.WithContext(ctx).Create(m).Error
}

func (r *refreshTokenRepository) FindByToken(ctx context.Context, token string) (*domain.RefreshToken, error) {
	var m refreshTokenModel
	err := r.db.WithContext(ctx).Where("token = ?", token).First(&m).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &domain.RefreshToken{
		ID:        m.ID,
		UserID:    m.UserID,
		Token:     m.Token,
		ExpiresAt: m.ExpiresAt,
		Revoked:   m.Revoked,
		CreatedAt: m.CreatedAt,
	}, nil
}

func (r *refreshTokenRepository) Revoke(ctx context.Context, token string) error {
	return r.db.WithContext(ctx).
		Model(&refreshTokenModel{}).
		Where("token = ?", token).
		Update("revoked", true).Error
}

func (r *refreshTokenRepository) RevokeByUserID(ctx context.Context, userID uuid.UUID) error {
	return r.db.WithContext(ctx).
		Model(&refreshTokenModel{}).
		Where("user_id = ? AND revoked = false", userID).
		Update("revoked", true).Error
}
