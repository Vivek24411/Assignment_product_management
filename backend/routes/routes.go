package routes

import (
	"product-management-backend/handlers"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine, productHandler *handlers.ProductHandler) {
	api := r.Group("/api")
	{
		products := api.Group("/products")
		{
			products.GET("", productHandler.GetProducts)
			products.GET("/:id", productHandler.GetProduct)
			products.POST("", productHandler.CreateProduct)
			products.PUT("/:id", productHandler.UpdateProduct)
			products.DELETE("/:id", productHandler.DeleteProduct)
		}
	}
}
