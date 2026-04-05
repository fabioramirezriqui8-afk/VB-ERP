package http

import (
	"github.com/gofiber/fiber/v2"
	"github.com/vctr/vb-erp/internal/identity/application/usecase"
	response "github.com/vctr/vb-erp/internal/shared/infrastructure/http"
)

type RolesHandler struct {
	uc *usecase.RolesUsecase
}

func NewRolesHandler(uc *usecase.RolesUsecase) *RolesHandler {
	return &RolesHandler{uc: uc}
}

func (h *RolesHandler) List(c *fiber.Ctx) error {
	roles, err := h.uc.List(c.Context())
	if err != nil {
		return mapError(c, err)
	}
	return response.OK(c, fiber.Map{
		"items": roles,
		"total": len(roles),
	})
}
