package http

import (
	"github.com/gofiber/fiber/v2"
	"github.com/vctr/vb-erp/internal/identity/delivery/middleware"
)

func RegisterRoutes(
	app *fiber.App,
	authH *AuthHandler,
	usersH *UsersHandler,
	rolesH *RolesHandler,
	permsH *PermissionsHandler,
	mw *middleware.AuthMiddleware,
) {
	v1 := app.Group("/api/v1")

	// Rutas públicas
	auth := v1.Group("/auth")
	auth.Post("/register", authH.Register)
	auth.Post("/login", authH.Login)
	auth.Post("/refresh", authH.Refresh)

	// Rutas protegidas
	protected := v1.Group("", mw.Authenticate)
	protected.Post("/auth/logout", authH.Logout)
	protected.Get("/me", authH.Me)

	// Administracion
	users := protected.Group("/users")
	users.Get("", usersH.List)
	users.Post("", usersH.Create)

	roles := protected.Group("/roles")
	roles.Get("", rolesH.List)

	permissions := protected.Group("/permissions")
	permissions.Get("", permsH.List)
}
