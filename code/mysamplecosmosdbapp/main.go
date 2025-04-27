package main

import (
	"example/bike-shop/data"
	"net/http"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	router.Use(cors.New(cors.Config{
		AllowOrigins:  []string{"*"}, // Allows all origins
		AllowMethods:  []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:  []string{"Origin", "Content-Type", "Accept"},
		ExposeHeaders: []string{"Content-Length"},
	}))

	setRoutes(router)

	// load the data from the database once at startup
	data.LoadAllItems()

	router.Run() // listen and serve on 0.0.0.0:8080
}

func setRoutes(router *gin.Engine) {

	router.GET("/api/items", getAllbikes)
	router.GET("/api/item/:collection/:id", getBikeByID)
	router.GET("/api/brands/:brand", getAllbikesByBrand)
	router.GET("/api/collections/:collection", getBikeByCategory)
	router.GET("/api/collections/:collection/:subcollection", getBikeByCategory)

	// Serve static files from the "client-app/build" directory
	router.GET("/", getClientApplication)
	router.NoRoute(getStaticFile)
}

func getClientApplication(c *gin.Context) {
	c.File("./client-app/dist/index.html")
}

func getStaticFile(c *gin.Context) {
	if _, err := os.Stat("./client-app/dist/" + c.Request.URL.Path); os.IsNotExist(err) {
		// file does not exist, return the default index.html
		c.File("./client-app/dist/index.html")
	}
	c.File("./client-app/dist/" + c.Request.URL.Path)
}

func getAllbikes(c *gin.Context) {
	items := data.GetAllItems()
	c.JSON(http.StatusOK, gin.H{
		"items": items,
	})
}

func getBikeByID(c *gin.Context) {
	collection := c.Param("collection")
	id := c.Param("id")
	item := data.GetItemByID(collection, id)
	c.JSON(http.StatusOK, gin.H{
		"item": item,
	})
}

func getAllbikesByBrand(c *gin.Context) {
	brand := c.Param("brand")
	items := data.GetItemsByBrand(brand)
	c.JSON(http.StatusOK, gin.H{
		"items": items,
	})
}

func getBikeByCategory(c *gin.Context) {
	collection := c.Param("collection")
	subcollection := c.Param("subcollection")
	items := data.GetItemsByCategory(collection, subcollection)
	c.JSON(http.StatusOK, gin.H{
		"items": items,
	})
}
