package main

import (
	"log"
	"net/http"
	"os"

	"product-management-backend/config"
	"product-management-backend/handlers"
	"product-management-backend/repository"
	"product-management-backend/routes"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	dbPath := os.Getenv("DB_PATH")
	if dbPath == "" {
		dbPath = "products.db"
	}

	db, err := config.NewDatabase(dbPath)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	productRepo := repository.NewProductRepository(db)
	productHandler := handlers.NewProductHandler(productRepo)

	r := gin.Default()

	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"http://localhost:3000", "http://localhost:8080"}
	config.AllowMethods = []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}
	config.AllowHeaders = []string{"Origin", "Content-Type", "Accept", "Authorization"}

	r.Use(cors.New(config))

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "ok",
			"message": "Product Management API is running",
		})
	})

	routes.SetupRoutes(r, productHandler)

	log.Println("Server starting on port 8080...")
	if err := r.Run(":8080"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}
