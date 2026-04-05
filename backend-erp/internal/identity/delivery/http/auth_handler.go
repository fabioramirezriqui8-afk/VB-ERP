package http

import (
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/vctr/vb-erp/internal/identity/application/dto"
	"github.com/vctr/vb-erp/internal/identity/application/usecase"
	sharedDomain "github.com/vctr/vb-erp/internal/shared/domain"
	response "github.com/vctr/vb-erp/internal/shared/infrastructure/http"
)

type AuthHandler struct {
	authUC *usecase.AuthUsecase
}

func NewAuthHandler(authUC *usecase.AuthUsecase) *AuthHandler {
	return &AuthHandler{authUC: authUC}
}

func (h *AuthHandler) Register(c *fiber.Ctx) error {
	var req dto.RegisterRequest
	if err := c.BodyParser(&req); err != nil {
		return response.BadRequest(c, "invalid request body")
	}
	res, err := h.authUC.Register(c.Context(), req)
	if err != nil {
		return mapError(c, err)
	}
	return response.Created(c, res)
}

func (h *AuthHandler) Login(c *fiber.Ctx) error {
	var req dto.LoginRequest
	if err := c.BodyParser(&req); err != nil {
		return response.BadRequest(c, "invalid request body")
	}
	res, err := h.authUC.Login(c.Context(), req)
	if err != nil {
		return mapError(c, err)
	}
	return response.OK(c, res)
}

func (h *AuthHandler) Refresh(c *fiber.Ctx) error {
	var req dto.RefreshRequest
	if err := c.BodyParser(&req); err != nil {
		return response.BadRequest(c, "invalid request body")
	}
	res, err := h.authUC.Refresh(c.Context(), req)
	if err != nil {
		return mapError(c, err)
	}
	return response.OK(c, res)
}

func (h *AuthHandler) Logout(c *fiber.Ctx) error {
	idStr, _ := c.Locals("userID").(string)
	id, err := uuid.Parse(idStr)
	if err != nil {
		return response.Unauthorized(c, "invalid session")
	}
	if err := h.authUC.Logout(c.Context(), id); err != nil {
		return response.InternalError(c)
	}
	return response.OKMessage(c, "logged out successfully")
}

func (h *AuthHandler) Me(c *fiber.Ctx) error {
	idStr, _ := c.Locals("userID").(string)
	id, err := uuid.Parse(idStr)
	if err != nil {
		return response.Unauthorized(c, "invalid session")
	}
	user, err := h.authUC.GetByID(c.Context(), id)
	if err != nil {
		return mapError(c, err)
	}
	return response.OK(c, user)
}

func mapError(c *fiber.Ctx, err error) error {
	if !sharedDomain.IsDomainError(err) {
		return response.InternalError(c)
	}
	de := err.(*sharedDomain.DomainError)
	switch de.Code {
	case "NOT_FOUND":
		return response.NotFound(c, de.Message)
	case "ALREADY_EXISTS":
		return response.Conflict(c, de.Message)
	case "UNAUTHORIZED":
		return response.Unauthorized(c, de.Message)
	case "FORBIDDEN":
		return response.Forbidden(c)
	case "INVALID_INPUT":
		return response.BadRequest(c, de.Message)
	default:
		return response.InternalError(c)
	}
}
