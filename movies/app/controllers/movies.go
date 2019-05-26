package controllers

import (
	"fmt"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"

	"github.com/mcasper/home/movies/app/routes"
	"github.com/revel/revel"
)

type Location struct {
	gorm.Model
	Name string
}

type Movie struct {
	gorm.Model
	Title      string
	LocationID int
	Location   Location
}

type Movies struct {
	*revel.Controller
}

func (c Movies) Index() revel.Result {
	db, connErr := gorm.Open("postgres", "postgres://localhost/movies_development?sslmode=disable")
	if connErr != nil {
		panic(fmt.Sprintf("failed to connect to database %v: %v", "movies_development", connErr))
	}
	defer db.Close()

	var movies []Movie
	if moviesQueryErr := db.Preload("Location").Find(&movies).Error; moviesQueryErr != nil {
		panic(fmt.Sprintf("encountered an error searching for movies: %v", moviesQueryErr))
	}

	groupedMovies := make(map[string][]Movie)
	for _, movie := range movies {
		groupedMovies[movie.Location.Name] = append(groupedMovies[movie.Location.Name], movie)
	}

	return c.Render(groupedMovies)
}

func (c Movies) New() revel.Result {
	db, connErr := gorm.Open("postgres", "postgres://localhost/movies_development?sslmode=disable")
	if connErr != nil {
		panic(fmt.Sprintf("failed to connect to database %v: %v", "movies_development", connErr))
	}
	defer db.Close()

	var locations []Location
	if locationsQueryErr := db.Find(&locations).Error; locationsQueryErr != nil {
		panic(fmt.Sprintf("encountered an error searching for locations: %v", locationsQueryErr))
	}

	return c.Render(locations)
}

func (c Movies) Create(movie Movie) revel.Result {
	db, connErr := gorm.Open("postgres", "postgres://localhost/movies_development?sslmode=disable")
	if connErr != nil {
		panic(fmt.Sprintf("failed to connect to database %v: %v", "movies_development", connErr))
	}
	defer db.Close()

	if movieValidationErr := validateMovie(movie); movieValidationErr != nil {
		return c.Redirect(routes.Movies.New())
	}

	if movieCreateErr := db.Create(&movie).Error; movieCreateErr != nil {
		panic(fmt.Sprintf("encountered an error creating a movie: %v", movieCreateErr))
	}

	return c.Redirect(routes.Movies.Index())
}

type ValidationError struct {
	s string
}

func (e *ValidationError) Error() string {
	return e.s
}

func validateMovie(movie Movie) error {
	if movie.Title == "" {
		return &ValidationError{s: "Error"}
	} else {
		return nil
	}
}
