package main

import (
	"github.com/dgrijalva/jwt-go"

	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strings"
)

type Claims struct {
	Name string `json:"name"`
	jwt.StandardClaims
}

type meHandler struct{}

func (h *meHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	authorizationHeaders := r.Header["Authorization"]

	if len(authorizationHeaders) != 1 {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	authorizationHeader := authorizationHeaders[0]

	if !strings.Contains(authorizationHeader, "Bearer ") {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	jwtString := strings.TrimPrefix(authorizationHeader, "Bearer ")
	token, jwtDecodeErr := jwt.ParseWithClaims(string(jwtString), &Claims{}, func(token *jwt.Token) (interface{}, error) {
		// Don't forget to validate the alg is what you expect:
		if _, ok := token.Method.(*jwt.SigningMethodECDSA); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}

		return ecdsaPrivateKey().Public(), nil
	})

	if claims, ok := token.Claims.(*Claims); ok && token.Valid {
		json.NewEncoder(w).Encode(claims)
	} else {
		log.Println("Error decoding JWT:", jwtDecodeErr)
		w.WriteHeader(http.StatusUnauthorized)
	}
}
