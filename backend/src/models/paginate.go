package models

import "gorm.io/gorm"

type Paginate struct {
	Limit int
	Page  int
	Sort  string
}

var (
	PAGINATE_DEFAULT_LIMIT = 50
	PAGINATE_DEFAULT_PAGE  = 1
	PAGINATE_DEFAULT_SORT  = "newest"
)

func BuildQueryFromPaginate(db *gorm.DB, pagination *Paginate) (*gorm.DB, error) {
	offset := (pagination.Page - 1) * pagination.Limit
	query := db.Limit(pagination.Limit).Offset(offset)
	return query, query.Error
}

// func GetAllUsers(user *User, pagination *Pagination) (*[]User, error) {
// 	var users []models.User
// 	offset := (pagination.Page - 1) * pagination.Limit
// 	queryBuider := Config.DB.Limit(pagination.Limit).Offset(offset).Order(pagination.Sort)
// 	result := queryBuider.Model(&models.User{}).Where(user).Find(&users)
// 	if result.Error != nil {
// 		msg := result.Error
// 		return nil, msg
// 	}
// 	return &users, nil
// }
