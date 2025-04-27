package data

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore/policy"
	"github.com/Azure/azure-sdk-for-go/sdk/data/azcosmos"
)

var cosmosDatabaseName = os.Getenv("COSMOS_DATABASE_NAME")
var cosmosContainerName = os.Getenv("COSMOS_CONTAINER_NAME")
var cosmosConnectionString = os.Getenv("COSMOS_CONNECTION_STRING")

func GetAllItems() []Item {

	container, err := getContainer()
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}

	partitionKey := azcosmos.NewPartitionKey()

	query := fmt.Sprintf("SELECT * FROM %s p", cosmosContainerName)

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	pager := container.NewQueryItemsPager(query, partitionKey, nil)

	items := []Item{}

	for pager.More() {
		response, err := pager.NextPage(ctx)
		if err != nil {
			// Handle the error appropriately
			panic(err)
		}

		for _, bytes := range response.Items {
			item := Item{}
			err := json.Unmarshal(bytes, &item)
			if err != nil {
				// Handle the error appropriately
				panic(err)
			}
			items = append(items, item)
		}
	}

	return items
}

func GetItemByID(category string, id string) Item {
	container, err := getContainer()
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	partitionKey := azcosmos.NewPartitionKeyString(category)
	itemBytes, err := container.ReadItem(ctx, partitionKey, id, nil)
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}

	item := Item{}
	err = json.Unmarshal(itemBytes.Value, &item)
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}

	return item
}

func GetItemsByBrand(brand string) []Item {
	container, err := getContainer()
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}
	items := []Item{}

	partitionKey := azcosmos.NewPartitionKey()

	query := fmt.Sprintf("SELECT * FROM %s p WHERE p.brand = @brand", cosmosContainerName)

	queryOptions := azcosmos.QueryOptions{
		QueryParameters: []azcosmos.QueryParameter{
			{Name: "@brand", Value: strings.ToLower(brand)},
		},
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	pager := container.NewQueryItemsPager(query, partitionKey, &queryOptions)

	for pager.More() {
		response, err := pager.NextPage(ctx)
		if err != nil {
			// Handle the error appropriately
			panic(err)
		}

		for _, bytes := range response.Items {
			item := Item{}
			err := json.Unmarshal(bytes, &item)
			if err != nil {
				// Handle the error appropriately
				panic(err)
			}
			items = append(items, item)
		}
	}

	return items
}

func GetItemsByCategory(category string, subcategory string) []Item {
	container, err := getContainer()
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}

	partitionKey := azcosmos.NewPartitionKeyString(category)

	var query string
	if subcategory != "" {
		query = fmt.Sprintf("SELECT * FROM %s p WHERE p.subcategory = @subcategory", cosmosContainerName)
	} else {
		query = fmt.Sprintf("SELECT * FROM %s p", cosmosContainerName)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	queryOptions := azcosmos.QueryOptions{
		QueryParameters: []azcosmos.QueryParameter{
			{Name: "@subcategory", Value: strings.ToLower(subcategory)},
		},
	}

	pager := container.NewQueryItemsPager(query, partitionKey, &queryOptions)

	items := []Item{}

	for pager.More() {
		response, err := pager.NextPage(ctx)
		if err != nil {
			// Handle the error appropriately
			panic(err)
		}

		for _, bytes := range response.Items {
			item := Item{}
			err := json.Unmarshal(bytes, &item)
			if err != nil {
				// Handle the error appropriately
				panic(err)
			}
			items = append(items, item)
		}
	}

	return items
}

func LoadAllItems() bool {

	if checkDataExists() {
		// Data already exists, no need to load again
		fmt.Println("Data already exists in the database. Skipping load.")
		return true
	}

	container, err := getContainer()
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}

	items, err := readJSONFile()

	if err != nil {
		// Handle the error appropriately
		panic(err)
	}

	for _, item := range items {

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		itemBytes, err := json.Marshal(item)
		if err != nil {
			// Handle the error appropriately
			panic(err)
		}
		containerItem, err := container.CreateItem(ctx, azcosmos.NewPartitionKeyString(item.Category), itemBytes, nil)
		if err != nil {
			// Handle the error appropriately
			panic(err)
		}
		if containerItem.RawResponse.StatusCode != 201 {
			return false
		}
	}
	return true
}

func getConnection() (*azcosmos.Client, error) {

	clientOptions := azcosmos.ClientOptions{}
	clientOptions.Retry = policy.RetryOptions{
		MaxRetries:    3,
		MaxRetryDelay: 30,
	}

	client, err := azcosmos.NewClientFromConnectionString(cosmosConnectionString, &clientOptions)
	if err != nil {
		return nil, err
	}

	return client, nil
}

func getDatabase(client *azcosmos.Client) (*azcosmos.DatabaseClient, error) {
	database, err := client.NewDatabase(cosmosDatabaseName)
	if err != nil {
		return nil, err
	}

	return database, nil
}

func getContainer() (*azcosmos.ContainerClient, error) {
	client, err := getConnection()
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}

	database, err := getDatabase(client)
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}

	container, err := database.NewContainer(cosmosContainerName)
	if err != nil {
		return nil, err
	}

	return container, nil
}

// readJSONFile reads a JSON file and unmarshals its content into a slice of Item.
func readJSONFile() ([]Item, error) {

	file, err := os.Open("./data/dataset.json")
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var items []Item
	decoder := json.NewDecoder(file)
	err = decoder.Decode(&items)
	if err != nil {
		return nil, err
	}

	return items, nil
}

func checkDataExists() bool {
	container, err := getContainer()
	if err != nil {
		// Handle the error appropriately
		panic(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	partitionKey := azcosmos.NewPartitionKey()
	pager := container.NewQueryItemsPager("SELECT p.id FROM Products p", partitionKey, nil)

	for pager.More() {
		queryResponse, err := pager.NextPage(ctx)
		if err != nil {
			fmt.Println("Error executing query:", err)
			return false
		}
		if len(queryResponse.Items) > 0 {
			return true
		}
	}
	return false
}
