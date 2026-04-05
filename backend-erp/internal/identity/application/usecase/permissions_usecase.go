package usecase

import (
	"context"

	"github.com/vctr/vb-erp/internal/identity/application/dto"
	domain "github.com/vctr/vb-erp/internal/identity/domain"
)

type PermissionsUsecase struct {
	repo domain.PermissionRepository
}

func NewPermissionsUsecase(repo domain.PermissionRepository) *PermissionsUsecase {
	return &PermissionsUsecase{repo: repo}
}

func (uc *PermissionsUsecase) List(ctx context.Context) ([]*dto.PermissionResponse, error) {
	perms, err := uc.repo.List(ctx)
	if err != nil {
		return nil, err
	}

	var res []*dto.PermissionResponse
	for _, p := range perms {
		res = append(res, toPermissionResponse(p))
	}
	return res, nil
}

func toPermissionResponse(p *domain.Permission) *dto.PermissionResponse {
	return &dto.PermissionResponse{
		ID:          p.ID.String(),
		Name:        p.Name,
		Description: p.Description,
		Module:      p.Module,
		Action:      p.Action,
		CreatedAt:   p.CreatedAt,
	}
}
