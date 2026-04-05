package mongo

import (
	"context"
	"log"
	"time"

	"github.com/vctr/vb-erp/internal/config"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func New(cfg *config.Config) *mongo.Database {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	client, err := mongo.Connect(ctx, options.Client().ApplyURI(cfg.Mongo.URI))
	if err != nil {
		log.Printf("mongo: connection failed (%v) — continuing without mongo", err)
		return nil
	}

	if err := client.Ping(ctx, nil); err != nil {
		log.Printf("mongo: ping failed (%v) — continuing without mongo", err)
		return nil
	}

	log.Println("mongo: connected")
	return client.Database(cfg.Mongo.Database)
}
