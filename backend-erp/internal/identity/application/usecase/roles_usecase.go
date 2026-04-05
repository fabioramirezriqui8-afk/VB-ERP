package usecase

import (
	"context"

	"github.com/vctr/vb-erp/internal/identity/application/dto"
	domain "github.com/vctr/vb-erp/internal/identity/domain"
)

type RolesUsecase struct {
	roleRepo domain.RoleRepository
}

func NewRolesUsecase(roleRepo domain.RoleRepository) *RolesUsecase {
	return &RolesUsecase{roleRepo: roleRepo}
}

func (uc *RolesUsecase) List(ctx context.Context) ([]*dto.RoleResponse, error) {
	roles, err := uc.roleRepo.List(ctx)
	if err != nil {
		return nil, err
	}

	var res []*dto.RoleResponse
	for _, r := range roles {
		res = append(res, toRoleResponse(r))
	}
	return res, nil
}

func toRoleResponse(r *domain.Role) *dto.RoleResponse {
	perms := make([]string, len(r.Permissions))
	for i, p := range r.Permissions {
		perms[i] = p.Name
	}
	return &dto.RoleResponse{
		ID:          r.ID.String(),
		Name:        r.Name,
		Description: r.Description,
		Permissions: perms,
	}
}
