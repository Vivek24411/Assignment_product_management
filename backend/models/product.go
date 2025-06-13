package models

import (
	"time"

	"gorm.io/gorm"
)

type Product struct {
	ID        uint           `json:"id" gorm:"primaryKey"`
	Name      string         `json:"name" gorm:"not null;size:255" binding:"required"`
	Category  string         `json:"category" gorm:"not null;size:100" binding:"required"`
	Quantity  int            `json:"quantity" gorm:"not null;default:0" binding:"required,min=0"`
	Price     float64        `json:"price" gorm:"not null;type:decimal(10,2)" binding:"required,min=0"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
}

type CreateProductRequest struct {
	Name     string  `json:"name" binding:"required,min=2"`
	Category string  `json:"category" binding:"required"`
	Quantity int     `json:"quantity" binding:"required,min=0"`
	Price    float64 `json:"price" binding:"required,min=0"`
}

type UpdateProductRequest struct {
	Name     string  `json:"name" binding:"required,min=2"`
	Category string  `json:"category" binding:"required"`
	Quantity int     `json:"quantity" binding:"required,min=0"`
	Price    float64 `json:"price" binding:"required,min=0"`
}

type ProductFilter struct {
	Category    string `form:"category"`
	InStock     *bool  `form:"in_stock"`
	StockFilter string `form:"stock_filter"`
}
