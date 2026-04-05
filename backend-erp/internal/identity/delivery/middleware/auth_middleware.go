package middleware

import (
	"strings"

	"github.com/gofiber/fiber/v2"
	response "github.com/vctr/vb-erp/internal/shared/infrastructure/http"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/jwt"
)

type AuthMiddleware struct {
	jwtManager *jwt.Manager
}

func NewAuthMiddleware(jwtMgr *jwt.Manager) *AuthMiddleware {
	return &AuthMiddleware{jwtManager: jwtMgr}
}

// Authenticate valida el JWT y carga el contexto del usuario
func (m *AuthMiddleware) Authenticate(c *fiber.Ctx) error {
	header := c.Get("Authorization")
	if !strings.HasPrefix(header, "Bearer ") {
		return response.Unauthorized(c, "missing authorization header")
	}

	claims, err := m.jwtManager.Validate(strings.TrimPrefix(header, "Bearer "))
	if err != nil {
		return response.Unauthorized(c, "invalid or expired token")
	}

	c.Locals("userID", claims.UserID.String())
	c.Locals("userEmail", claims.Email)
	c.Locals("userRoles", claims.Roles)
	c.Locals("userPermissions", claims.Permissions)
	return c.Next()
}

// RequirePermission verifica que el usuario tenga un permiso específico
func (m *AuthMiddleware) RequirePermission(permission string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		perms, _ := c.Locals("userPermissions").([]string)
		for _, p := range perms {
			if p == permission {
				return c.Next()
			}
		}
		return response.Forbidden(c)
	}
}

// RequireRole verifica que el usuario tenga un rol específico
func (m *AuthMiddleware) RequireRole(role string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		roles, _ := c.Locals("userRoles").([]string)
		for _, r := range roles {
			if r == role {
				return c.Next()
			}
		}
		return response.Forbidden(c)
	}
}
