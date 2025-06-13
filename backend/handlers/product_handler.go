package handlers

import (
	"net/http"

	"product-management-backend/models"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type ProductHandler struct {
	products []models.Product
}

func NewProductHandler() *ProductHandler {
	return &ProductHandler{
		products: make([]models.Product, 0),
	}
}

func (h *ProductHandler) GetProducts(c *gin.Context) {
	var filter models.ProductFilter
	if err := c.ShouldBindQuery(&filter); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	filteredProducts := h.filterProducts(filter)
	c.JSON(http.StatusOK, filteredProducts)
}

func (h *ProductHandler) GetProduct(c *gin.Context) {
	id := c.Param("id")

	for _, product := range h.products {
		if product.ID == id {
			c.JSON(http.StatusOK, product)
			return
		}
	}

	c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
}

func (h *ProductHandler) CreateProduct(c *gin.Context) {
	var req models.CreateProductRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	product := models.Product{
		ID:       uuid.New().String(),
		Name:     req.Name,
		Category: req.Category,
		Quantity: req.Quantity,
		Price:    req.Price,
	}

	h.products = append(h.products, product)
	c.JSON(http.StatusCreated, product)
}

func (h *ProductHandler) UpdateProduct(c *gin.Context) {
	id := c.Param("id")

	var req models.UpdateProductRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	for i, product := range h.products {
		if product.ID == id {
			h.products[i].Name = req.Name
			h.products[i].Category = req.Category
			h.products[i].Quantity = req.Quantity
			h.products[i].Price = req.Price

			c.JSON(http.StatusOK, h.products[i])
			return
		}
	}

	c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
}

func (h *ProductHandler) DeleteProduct(c *gin.Context) {
	id := c.Param("id")

	for i, product := range h.products {
		if product.ID == id {
			h.products = append(h.products[:i], h.products[i+1:]...)
			c.Status(http.StatusNoContent)
			return
		}
	}

	c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
}

func (h *ProductHandler) filterProducts(filter models.ProductFilter) []models.Product {
	var filtered []models.Product

	for _, product := range h.products {
		if filter.Category != "" && product.Category != filter.Category {
			continue
		}

		if filter.InStock != nil {
			if *filter.InStock && product.Quantity <= 0 {
				continue
			}
			if !*filter.InStock && product.Quantity > 0 {
				continue
			}
		}

		if filter.StockFilter != "" {
			switch filter.StockFilter {
			case "in_stock":
				if product.Quantity <= 5 {
					continue
				}
			case "low_stock":
				if product.Quantity > 5 || product.Quantity <= 0 {
					continue
				}
			case "out_of_stock":
				if product.Quantity > 0 {
					continue
				}
			}
		}

		filtered = append(filtered, product)
	}

	return filtered
}
