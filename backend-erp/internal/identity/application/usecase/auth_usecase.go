package usecase

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"time"

	"github.com/google/uuid"
	"github.com/vctr/vb-erp/internal/identity/application/dto"
	domain "github.com/vctr/vb-erp/internal/identity/domain"
	sharedDomain "github.com/vctr/vb-erp/internal/shared/domain"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/jwt"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/password"
)

type AuthUsecase struct {
	userRepo    domain.UserRepository
	tokenRepo   domain.RefreshTokenRepository
	jwtManager  *jwt.Manager
}

func NewAuthUsecase(
	userRepo domain.UserRepository,
	tokenRepo domain.RefreshTokenRepository,
	jwtMgr *jwt.Manager,
) *AuthUsecase {
	return &AuthUsecase{userRepo: userRepo, tokenRepo: tokenRepo, jwtManager: jwtMgr}
}

func (uc *AuthUsecase) Register(ctx context.Context, req dto.RegisterRequest) (*dto.AuthResponse, error) {
	email, err := sharedDomain.NewEmail(req.Email)
	if err != nil {
		return nil, sharedDomain.ErrInvalidInput
	}

	if existing, _ := uc.userRepo.FindByEmail(ctx, email); existing != nil {
		return nil, sharedDomain.AlreadyExistsError("email")
	}

	hashed, err := password.Hash(req.Password)
	if err != nil {
		return nil, sharedDomain.ErrInternalServer
	}

	user := domain.NewUser(req.Name, email, hashed)
	user.AddEvent(domain.NewUserRegisteredEvent(user.ID, user.Name))

	if err := uc.userRepo.Create(ctx, user); err != nil {
		return nil, err
	}

	return uc.buildAuthResponse(ctx, user)
}

func (uc *AuthUsecase) Login(ctx context.Context, req dto.LoginRequest) (*dto.AuthResponse, error) {
	email, err := sharedDomain.NewEmail(req.Email)
	if err != nil {
		return nil, sharedDomain.ErrInvalidInput
	}

	user, err := uc.userRepo.FindByEmail(ctx, email)
	if err != nil || user == nil || !password.Verify(user.Password, req.Password) {
		return nil, sharedDomain.ErrUnauthorized
	}

	if !user.Active {
		return nil, sharedDomain.ErrForbidden
	}

	return uc.buildAuthResponse(ctx, user)
}

func (uc *AuthUsecase) Refresh(ctx context.Context, req dto.RefreshRequest) (*dto.AuthResponse, error) {
	rt, err := uc.tokenRepo.FindByToken(ctx, req.RefreshToken)
	if err != nil || rt == nil || !rt.IsValid() {
		return nil, sharedDomain.ErrUnauthorized
	}

	user, err := uc.userRepo.FindByID(ctx, rt.UserID)
	if err != nil || user == nil || !user.Active {
		return nil, sharedDomain.ErrUnauthorized
	}

	// Rotar el refresh token
	if err := uc.tokenRepo.Revoke(ctx, req.RefreshToken); err != nil {
		return nil, sharedDomain.ErrInternalServer
	}

	return uc.buildAuthResponse(ctx, user)
}

func (uc *AuthUsecase) Logout(ctx context.Context, userID uuid.UUID) error {
	return uc.tokenRepo.RevokeByUserID(ctx, userID)
}

func (uc *AuthUsecase) GetByID(ctx context.Context, id uuid.UUID) (*dto.UserResponse, error) {
	user, err := uc.userRepo.FindByID(ctx, id)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, sharedDomain.NotFoundError("user")
	}
	return toUserResponse(user), nil
}

// ── helpers ───────────────────────────────────────────────────────────────────

func (uc *AuthUsecase) buildAuthResponse(ctx context.Context, user *domain.User) (*dto.AuthResponse, error) {
	perms := collectPermissions(user)

	accessToken, err := uc.jwtManager.Generate(user.ID, user.Email.String(), user.RoleNames(), perms)
	if err != nil {
		return nil, sharedDomain.ErrInternalServer
	}

	rawToken, _ := generateToken()
	rt := &domain.RefreshToken{
		ID:        uuid.New(),
		UserID:    user.ID,
		Token:     rawToken,
		ExpiresAt: time.Now().Add(7 * 24 * time.Hour),
	}
	if err := uc.tokenRepo.Save(ctx, rt); err != nil {
		return nil, sharedDomain.ErrInternalServer
	}

	return &dto.AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: rawToken,
		User:         *toUserResponse(user),
	}, nil
}

func toUserResponse(u *domain.User) *dto.UserResponse {
	return &dto.UserResponse{
		ID:          u.ID.String(),
		Name:        u.Name,
		Email:       u.Email.String(),
		Roles:       u.RoleNames(),
		Permissions: collectPermissions(u),
	}
}

func collectPermissions(u *domain.User) []string {
	seen := map[string]struct{}{}
	for _, r := range u.Roles {
		for _, p := range r.Permissions {
			seen[p.Name] = struct{}{}
		}
	}
	perms := make([]string, 0, len(seen))
	for p := range seen {
		perms = append(perms, p)
	}
	return perms
}

func generateToken() (string, error) {
	b := make([]byte, 32)
	_, err := rand.Read(b)
	return hex.EncodeToString(b), err
}
