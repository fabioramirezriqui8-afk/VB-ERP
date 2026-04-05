// Package mongo contiene los seeds para MongoDB.
// Ejecutar con: go run migrations/mongo/seed.go
package main

import (
	"context"
	"log"
	"time"

	"github.com/vctr/vb-erp/internal/config"
	"github.com/vctr/vb-erp/internal/shared/infrastructure/mongo"
	mongoDriver "go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/bson"
)

func main() {
	cfg := config.Load()
	db := mongo.New(cfg)
	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	seedAuditLogs(ctx, db)
	log.Println("mongo seeds completed")
}

func seedAuditLogs(ctx context.Context, db *mongoDriver.Database) {
	col := db.Collection("audit_logs")

	// Índice TTL: logs se eliminan automáticamente después de 90 días
	_, err := col.Indexes().CreateOne(ctx, mongoDriver.IndexModel{
		Keys: bson.D{{Key: "occurred_at", Value: 1}},
	})
	if err != nil {
		log.Printf("mongo: audit_logs index: %v", err)
	}

	// Documento de ejemplo
	sample := bson.D{
		{Key: "event",       Value: "system.seeded"},
		{Key: "module",      Value: "system"},
		{Key: "actor_id",    Value: "00000000-0000-0000-0000-000000000001"},
		{Key: "occurred_at", Value: time.Now()},
		{Key: "metadata",    Value: bson.D{{Key: "note", Value: "initial seed"}}},
	}

	_, err = col.InsertOne(ctx, sample)
	if err != nil {
		log.Printf("mongo: seed insert: %v", err)
		return
	}
	log.Println("mongo: audit_logs seeded")
}
