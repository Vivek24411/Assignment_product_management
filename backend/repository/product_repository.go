package repository

import (
	"context"

	"product-management-backend/config"
	"product-management-backend/models"

	"gorm.io/gorm"
)

type ProductRepository struct {
	db *gorm.DB
}

func NewProductRepository(db *config.Database) *ProductRepository {
	return &ProductRepository{
		db: db.GetDB(),
	}
}

func (r *ProductRepository) Create(ctx context.Context, product *models.Product) error {
	return r.db.WithContext(ctx).Create(product).Error
}

func (r *ProductRepository) GetByID(ctx context.Context, id string) (*models.Product, error) {
	var product models.Product
	err := r.db.WithContext(ctx).First(&product, id).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &product, nil
}

func (r *ProductRepository) GetAll(ctx context.Context, filter models.ProductFilter) ([]models.Product, error) {
	query := r.db.WithContext(ctx).Model(&models.Product{})

	if filter.Category != "" {
		query = query.Where("category = ?", filter.Category)
	}

	if filter.InStock != nil {
		if *filter.InStock {
			query = query.Where("quantity > ?", 0)
		} else {
			query = query.Where("quantity <= ?", 0)
		}
	}

	if filter.StockFilter != "" {
		switch filter.StockFilter {
		case "in_stock":
			query = query.Where("quantity > ?", 5)
		case "low_stock":
			query = query.Where("quantity > ? AND quantity <= ?", 0, 5)
		case "out_of_stock":
			query = query.Where("quantity <= ?", 0)
		}
	}

	var products []models.Product
	err := query.Find(&products).Error
	return products, err
}

func (r *ProductRepository) Update(ctx context.Context, id string, product *models.Product) error {
	result := r.db.WithContext(ctx).Model(&models.Product{}).Where("id = ?", id).Updates(map[string]interface{}{
		"name":       product.Name,
		"category":   product.Category,
		"quantity":   product.Quantity,
		"price":      product.Price,
		"updated_at": gorm.Expr("CURRENT_TIMESTAMP"),
	})

	if result.Error != nil {
		return result.Error
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (r *ProductRepository) Delete(ctx context.Context, id string) error {
	result := r.db.WithContext(ctx).Delete(&models.Product{}, id)

	if result.Error != nil {
		return result.Error
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (r *ProductRepository) GetCategories(ctx context.Context) ([]string, error) {
	var categories []string
	err := r.db.WithContext(ctx).Model(&models.Product{}).
		Distinct().
		Pluck("category", &categories).
		Error
	return categories, err
}
