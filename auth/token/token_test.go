package token

import (
	"testing"
)

func TestNewToken(t *testing.T) {
	profileInfo := ProfileInfo{
		Sub:   "123",
		Name:  "Example User",
		Email: "user@example.com",
	}

	_, err := NewToken(profileInfo)
	if err != nil {
		t.Errorf("Failed to generate JWT: %s", err)
	}
}
