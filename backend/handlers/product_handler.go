package handlers

import (
	"context"
	"net/http"
	"time"

	"product-management-backend/models"
	"product-management-backend/repository"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type ProductHandler struct {
	repo *repository.ProductRepository
}

func NewProductHandler(repo *repository.ProductRepository) *ProductHandler {
	return &ProductHandler{
		repo: repo,
	}
}

func (h *ProductHandler) GetProducts(c *gin.Context) {
	ctx, cancel := context.WithTimeout(c.Request.Context(), 10*time.Second)
	defer cancel()

	var filter models.ProductFilter
	if err := c.ShouldBindQuery(&filter); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	products, err := h.repo.GetAll(ctx, filter)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch products"})
		return
	}

	c.JSON(http.StatusOK, products)
}

func (h *ProductHandler) GetProduct(c *gin.Context) {
	ctx, cancel := context.WithTimeout(c.Request.Context(), 10*time.Second)
	defer cancel()

	id := c.Param("id")

	product, err := h.repo.GetByID(ctx, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch product"})
		return
	}

	if product == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
		return
	}

	c.JSON(http.StatusOK, product)
}

func (h *ProductHandler) CreateProduct(c *gin.Context) {
	ctx, cancel := context.WithTimeout(c.Request.Context(), 10*time.Second)
	defer cancel()

	var req models.CreateProductRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	product := &models.Product{
		Name:     req.Name,
		Category: req.Category,
		Quantity: req.Quantity,
		Price:    req.Price,
	}

	if err := h.repo.Create(ctx, product); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create product"})
		return
	}

	c.JSON(http.StatusCreated, product)
}

func (h *ProductHandler) UpdateProduct(c *gin.Context) {
	ctx, cancel := context.WithTimeout(c.Request.Context(), 10*time.Second)
	defer cancel()

	id := c.Param("id")

	var req models.UpdateProductRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	product := &models.Product{
		Name:     req.Name,
		Category: req.Category,
		Quantity: req.Quantity,
		Price:    req.Price,
	}

	if err := h.repo.Update(ctx, id, product); err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update product"})
		return
	}

	updatedProduct, err := h.repo.GetByID(ctx, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch updated product"})
		return
	}

	c.JSON(http.StatusOK, updatedProduct)
}

func (h *ProductHandler) DeleteProduct(c *gin.Context) {
	ctx, cancel := context.WithTimeout(c.Request.Context(), 10*time.Second)
	defer cancel()

	id := c.Param("id")

	if err := h.repo.Delete(ctx, id); err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete product"})
		return
	}

	c.Status(http.StatusNoContent)
}
