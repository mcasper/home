package token

import (
	"github.com/dgrijalva/jwt-go"

	"crypto/ecdsa"
	"io/ioutil"
	"log"
	"os"
)

type ProfileInfo struct {
	Sub   string `json:"sub"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

func NewToken(profileInfo ProfileInfo) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodES256, jwt.MapClaims{
		"name": profileInfo.Name,
	})

	key := EcdsaPrivateKey()
	return token.SignedString(key)
}

func EcdsaPrivateKey() *ecdsa.PrivateKey {
	jwt_key_path := os.Getenv("JWT_KEY_PATH")
	if jwt_key_path == "" {
		log.Fatal("JWT_KEY_PATH is not set")
	}

	data, err := ioutil.ReadFile(jwt_key_path)
	if err != nil {
		log.Fatal("Error reading private key file: ", err)
	}
	ecdsaKey, ecdsaKeyErr := jwt.ParseECPrivateKeyFromPEM(data)
	if ecdsaKeyErr != nil {
		log.Fatal("Error parsing private key: ", ecdsaKeyErr)
	}
	return ecdsaKey
}
