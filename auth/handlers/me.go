package handlers

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/mcasper/home/auth/token"

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

type MeHandler struct{}

func (h *MeHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
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
	decodedToken, jwtDecodeErr := jwt.ParseWithClaims(string(jwtString), &Claims{}, func(jwtToken *jwt.Token) (interface{}, error) {
		// Don't forget to validate the alg is what you expect:
		if _, ok := jwtToken.Method.(*jwt.SigningMethodECDSA); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", jwtToken.Header["alg"])
		}

		return token.EcdsaPrivateKey().Public(), nil
	})

	if claims, ok := decodedToken.Claims.(*Claims); ok && decodedToken.Valid {
		json.NewEncoder(w).Encode(claims)
	} else {
		log.Println("Error decoding JWT:", jwtDecodeErr)
		w.WriteHeader(http.StatusUnauthorized)
	}
}
