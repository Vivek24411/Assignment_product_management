package config

import (
	"log"

	"product-management-backend/models"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

type Database struct {
	DB *gorm.DB
}

func NewDatabase(dbPath string) (*Database, error) {
	db, err := gorm.Open(sqlite.Open(dbPath), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		return nil, err
	}

	err = db.AutoMigrate(&models.Product{})
	if err != nil {
		return nil, err
	}

	log.Println("Connected to SQLite database successfully")
	log.Println("Database migrated successfully")

	return &Database{
		DB: db,
	}, nil
}

func (db *Database) GetDB() *gorm.DB {
	return db.DB
}
