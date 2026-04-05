package http

import (
	"github.com/gofiber/fiber/v2"
	"github.com/vctr/vb-erp/internal/identity/delivery/middleware"
)

func RegisterRoutes(app *fiber.App, h *AuthHandler, mw *middleware.AuthMiddleware) {
	v1 := app.Group("/api/v1")

	// Rutas públicas
	auth := v1.Group("/auth")
	auth.Post("/register", h.Register)
	auth.Post("/login", h.Login)
	auth.Post("/refresh", h.Refresh)

	// Rutas protegidas
	protected := v1.Group("", mw.Authenticate)
	protected.Post("/auth/logout", h.Logout)
	protected.Get("/me", h.Me)
}
