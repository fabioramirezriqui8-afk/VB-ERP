package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/vctr/vb-erp/internal/config"
	identityHTTP "github.com/vctr/vb-erp/internal/identity/delivery/http"
	"github.com/vctr/vb-erp/internal/identity/delivery/middleware"
	"github.com/vctr/vb-erp/internal/identity/application/usecase"
	"github.com/vctr/vb-erp/internal/identity/infrastructure/persistence"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/jwt"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/migrator"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/mongo"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/postgres"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/redis"
)

func main() {
	cfg := config.Load()

	// ── Infraestructura ───────────────────────────────────────────────────────
	db    := postgres.New(cfg)
	_      = redis.New(cfg)
	_      = mongo.New(cfg)

	// ── Migraciones PostgreSQL ────────────────────────────────────────────────
	if err := migrator.RunPostgres(cfg); err != nil {
		log.Fatalf("migration failed: %v", err)
	}

	// ── Identity module — wiring ──────────────────────────────────────────────
	jwtManager   := jwt.NewManager(cfg.JWT.Secret, cfg.JWT.ExpiryHours)
	userRepo     := persistence.NewUserRepository(db)
	tokenRepo    := persistence.NewRefreshTokenRepository(db)
	authUC       := usecase.NewAuthUsecase(userRepo, tokenRepo, jwtManager)
	authHandler  := identityHTTP.NewAuthHandler(authUC)
	authMW       := middleware.NewAuthMiddleware(jwtManager)

	// ── HTTP server ───────────────────────────────────────────────────────────
	app := fiber.New(fiber.Config{AppName: "VB-ERP API v1"})

	identityHTTP.RegisterRoutes(app, authHandler, authMW)

	log.Printf("server starting on :%s", cfg.AppPort)
	if err := app.Listen(":" + cfg.AppPort); err != nil {
		log.Fatalf("server error: %v", err)
	}
}
