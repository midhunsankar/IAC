package data

//************************************
//* Data Structure for the API
//************************************
// Item represents a product item in the store.
// Making this a generic item structure allows for easy expansion in the future.
// It can be used for any type of product, not just bikes.
type Item struct {
	ID          string   `json:"id"`
	Name        string   `json:"name"`
	Brand       string   `json:"brand"`
	Category    string   `json:"category"`
	Subcategory string   `json:"subcategory"`
	Price       float64  `json:"price"`
	Stock       int      `json:"stock"`
	Description string   `json:"description"`
	Subtitle    string   `json:"subtitle"`
	Thumb       string   `json:"thumb"`
	Images      []string `json:"images"`
	Gender      string   `json:"gender"`
}
