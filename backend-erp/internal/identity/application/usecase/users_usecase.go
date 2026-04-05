package usecase

import (
	"context"

	"github.com/google/uuid"
	"github.com/vctr/vb-erp/internal/identity/application/dto"
	domain "github.com/vctr/vb-erp/internal/identity/domain"
	sharedDomain "github.com/vctr/vb-erp/internal/shared/domain"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/password"
)

type UsersUsecase struct {
	userRepo domain.UserRepository
}

func NewUsersUsecase(userRepo domain.UserRepository) *UsersUsecase {
	return &UsersUsecase{userRepo: userRepo}
}

func (uc *UsersUsecase) Create(ctx context.Context, req dto.CreateUserRequest) (*dto.UserResponse, error) {
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
	if err := uc.userRepo.Create(ctx, user); err != nil {
		return nil, err
	}

	if req.RoleID != "" {
		rID, err := uuid.Parse(req.RoleID)
		if err == nil {
			_ = uc.userRepo.AssignRole(ctx, user.ID, rID)
		}
	}

	// Fetch again to get the assigned roles hydrated
	hydratedUser, _ := uc.userRepo.FindByID(ctx, user.ID)
	if hydratedUser != nil {
		user = hydratedUser
	}

	return toUserResponse(user), nil
}

func (uc *UsersUsecase) List(ctx context.Context, page sharedDomain.PageRequest) ([]*dto.UserResponse, int64, error) {
	users, total, err := uc.userRepo.List(ctx, page)
	if err != nil {
		return nil, 0, err
	}

	var res []*dto.UserResponse
	for _, u := range users {
		res = append(res, toUserResponse(u))
	}
	return res, total, nil
}
