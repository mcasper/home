package controllers

import (
	"fmt"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/revel/revel"
)

type Movie struct {
	gorm.Model
	Title string
}

type Movies struct {
	*revel.Controller
}

func (c Movies) Index() revel.Result {
	db, connErr := gorm.Open("postgres", "postgres://localhost/movies_development?sslmode=disable")
	db.LogMode(true)
	if connErr != nil {
		panic(fmt.Sprintf("failed to connect to database %v: %v", "movies_development", connErr))
	}
	defer db.Close()

	var movies []Movie
	if moviesQueryErr := db.Find(&movies).Error; moviesQueryErr != nil {
		panic(fmt.Sprintf("encountered an error searching for movies: %v", moviesQueryErr))
	}

	return c.Render(movies)
}
