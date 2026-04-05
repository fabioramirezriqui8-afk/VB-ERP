package migrator

import (
	"fmt"
	"log"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/vctr/vb-erp/internal/config"
)

// RunPostgres aplica todas las migraciones pendientes de PostgreSQL
func RunPostgres(cfg *config.Config) error {
	dsn := fmt.Sprintf(
		"postgres://%s:%s@%s:%s/%s?sslmode=disable",
		cfg.DB.User, cfg.DB.Password, cfg.DB.Host, cfg.DB.Port, cfg.DB.Name,
	)

	m, err := migrate.New("file://migrations/postgres", dsn)
	if err != nil {
		return fmt.Errorf("migrator: init failed: %w", err)
	}
	defer m.Close()

	if err := m.Up(); err != nil && err != migrate.ErrNoChange {
		return fmt.Errorf("migrator: up failed: %w", err)
	}

	log.Println("migrator: postgres up to date")
	return nil
}
