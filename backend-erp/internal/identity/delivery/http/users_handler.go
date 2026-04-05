package http

import (
	"strconv"

	"github.com/gofiber/fiber/v2"
	"github.com/vctr/vb-erp/internal/identity/application/dto"
	"github.com/vctr/vb-erp/internal/identity/application/usecase"
	sharedDomain "github.com/vctr/vb-erp/internal/shared/domain"
	response "github.com/vctr/vb-erp/internal/shared/infrastructure/http"
)

type UsersHandler struct {
	uc *usecase.UsersUsecase
}

func NewUsersHandler(uc *usecase.UsersUsecase) *UsersHandler {
	return &UsersHandler{uc: uc}
}

func (h *UsersHandler) List(c *fiber.Ctx) error {
	page, _ := strconv.Atoi(c.Query("page", "1"))
	limit, _ := strconv.Atoi(c.Query("limit", "20"))

	req := sharedDomain.PageRequest{Page: page, Limit: limit}
	req.Normalize()

	users, total, err := h.uc.List(c.Context(), req)
	if err != nil {
		return mapError(c, err)
	}

	pages := total / int64(req.Limit)
	if total%int64(req.Limit) != 0 {
		pages++
	}

	return response.OK(c, fiber.Map{
		"items":       users,
		"total":       total,
		"page":        req.Page,
		"limit":       req.Limit,
		"total_pages": pages,
	})
}

func (h *UsersHandler) Create(c *fiber.Ctx) error {
	var req dto.CreateUserRequest
	if err := c.BodyParser(&req); err != nil {
		return response.BadRequest(c, "cuerpo de solicitud inválido")
	}
	res, err := h.uc.Create(c.Context(), req)
	if err != nil {
		return mapError(c, err)
	}
	return response.Created(c, res)
}
