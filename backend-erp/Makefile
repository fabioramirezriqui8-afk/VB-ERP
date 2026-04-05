include .env
export

DB_URL=postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable

run:
	go run ./cmd/server/main.go

build:
	go build -o bin/server ./cmd/server/main.go

tidy:
	go mod tidy

# ── PostgreSQL migrations ─────────────────────────────────────────────────────
MIGRATE=$(HOME)/go/bin/migrate

migrate-up:
	$(MIGRATE) -path migrations/postgres -database "$(DB_URL)" up

migrate-down:
	$(MIGRATE) -path migrations/postgres -database "$(DB_URL)" down

migrate-down-one:
	$(MIGRATE) -path migrations/postgres -database "$(DB_URL)" down 1

migrate-status:
	$(MIGRATE) -path migrations/postgres -database "$(DB_URL)" version

migrate-force:
	$(MIGRATE) -path migrations/postgres -database "$(DB_URL)" force $(version)

# ── MongoDB seeds ─────────────────────────────────────────────────────────────
seed-mongo:
	go run migrations/mongo/seed.go

# ── Crear nueva migración ─────────────────────────────────────────────────────
# Uso: make migrate-create name=create_inventory_tables
migrate-create:
	migrate create -ext sql -dir migrations/postgres -seq $(name)

.PHONY: run build tidy migrate-up migrate-down migrate-down-one migrate-status migrate-force seed-mongo migrate-create
