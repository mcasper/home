// Code generated by github.com/99designs/gqlgen, DO NOT EDIT.

package tasks_backend

type NewTask struct {
	Text string `json:"text"`
}

type TaskUpdate struct {
	Complete *bool `json:"complete"`
}
