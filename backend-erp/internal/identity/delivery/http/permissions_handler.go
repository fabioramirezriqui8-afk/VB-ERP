package http

import (
	"github.com/gofiber/fiber/v2"
	"github.com/vctr/vb-erp/internal/identity/application/usecase"
	response "github.com/vctr/vb-erp/internal/shared/infrastructure/http"
)

type PermissionsHandler struct {
	uc *usecase.PermissionsUsecase
}

func NewPermissionsHandler(uc *usecase.PermissionsUsecase) *PermissionsHandler {
	return &PermissionsHandler{uc: uc}
}

func (h *PermissionsHandler) List(c *fiber.Ctx) error {
	perms, err := h.uc.List(c.Context())
	if err != nil {
		return mapError(c, err)
	}
	return response.OK(c, perms)
}
