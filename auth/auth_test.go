package main

import (
	"testing"
)

func TestNewToken(t *testing.T) {
	profileInfo := ProfileInfo{
		Sub:   "123",
		Name:  "Example User",
		Email: "user@example.com",
	}

	_, err := newToken(profileInfo)
	if err != nil {
		t.Errorf("Failed to generate JWT: %s", err)
	}
}
