package tasks_backend

import (
	"context"
	"fmt"
	"os"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
) // THIS CODE IS A STARTING POINT ONLY. IT WILL NOT BE UPDATED WITH SCHEMA CHANGES.

type Resolver struct{}

func (r *Resolver) Mutation() MutationResolver {
	return &mutationResolver{r}
}
func (r *Resolver) Query() QueryResolver {
	return &queryResolver{r}
}
func (r *Resolver) Task() TaskResolver {
	return &taskResolver{r}
}

type mutationResolver struct{ *Resolver }

func (r *mutationResolver) CreateTask(ctx context.Context, input NewTask) (*Task, error) {
	db := dbConnection()
	defer db.Close()

	task := &Task{
		Text:     input.Text,
		Complete: false,
	}

	if taskCreateErr := db.Create(&task).Error; taskCreateErr != nil {
		return nil, taskCreateErr
	}

	return task, nil
}

type queryResolver struct{ *Resolver }

func (r *queryResolver) Tasks(ctx context.Context) ([]*Task, error) {
	db := dbConnection()
	defer db.Close()

	var tasks []*Task
	if tasksQueryErr := db.Find(&tasks).Error; tasksQueryErr != nil {
		return nil, tasksQueryErr
	}
	return tasks, nil
}

type taskResolver struct{ *Resolver }

func (r *taskResolver) ID(ctx context.Context, obj *Task) (string, error) {
	return fmt.Sprint(obj.ID), nil
}

func dbConnection() *gorm.DB {
	databaseUrl := os.Getenv("TASKS_DATABASE_URL")
	if databaseUrl == "" {
		panic("TASKS_DATABASE_URL must be set")
	}

	db, connErr := gorm.Open("postgres", databaseUrl)
	if connErr != nil {
		panic(fmt.Sprintf("failed to connect to database %v: %v", databaseUrl, connErr))
	}
	return db
}
