package models

import (
	"time"
)

type Product struct {
	ID        string    `json:"id" bson:"_id,omitempty"`
	Name      string    `json:"name" bson:"name" binding:"required"`
	Category  string    `json:"category" bson:"category" binding:"required"`
	Quantity  int       `json:"quantity" bson:"quantity" binding:"required,min=0"`
	Price     float64   `json:"price" bson:"price" binding:"required,min=0"`
	CreatedAt time.Time `json:"created_at" bson:"created_at"`
	UpdatedAt time.Time `json:"updated_at" bson:"updated_at"`
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
