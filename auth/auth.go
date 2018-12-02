package main

import (
	"github.com/dgrijalva/jwt-go"
	"golang.org/x/oauth2"

	"crypto/ecdsa"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

type ProfileInfo struct {
	Sub   string `json:"sub"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

type authHandler struct{}

func (h *authHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	retrievedStateCookie, stateErr := r.Cookie("state")
	if stateErr != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("<html>Invalid state</html>"))
		return
	}
	if retrievedStateCookie.Value == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("<html>Invalid state</html>"))
		return
	}

	retrievedReturnToCookie, returnToErr := r.Cookie("returnTo")
	if returnToErr != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("<html>Invalid returnTo</html>"))
		return
	}
	if retrievedReturnToCookie.Value == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("<html>Invalid state</html>"))
		return
	}

	tok, err := conf.Exchange(oauth2.NoContext, r.FormValue("code"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(fmt.Sprintf("<html>Error: %v</html>", err)))
		return
	}

	client := conf.Client(oauth2.NoContext, tok)
	profileHandle, err := client.Get("https://www.googleapis.com/oauth2/v3/userinfo")
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(fmt.Sprintf("<html>Error: %v</html>", err)))
		return
	}
	defer profileHandle.Body.Close()
	profileInfoJson, _ := ioutil.ReadAll(profileHandle.Body)
	var profileInfo ProfileInfo
	json.Unmarshal(profileInfoJson, &profileInfo)
	jwt, jwtErr := newToken(profileInfo)
	if jwtErr != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(fmt.Sprintf("<html>Error: %v</html>", jwtErr)))
		return
	}
	redirectTo := retrievedReturnToCookie.Value + "?key=" + jwt

	http.Redirect(w, r, redirectTo, 302)
}

func newToken(profileInfo ProfileInfo) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodES256, jwt.MapClaims{
		"name": profileInfo.Name,
	})

	key := ecdsaPrivateKey()
	return token.SignedString(key)
}

func ecdsaPrivateKey() *ecdsa.PrivateKey {
	data, err := ioutil.ReadFile("./key.pem")
	if err != nil {
		log.Fatal("Error reading private key file: ", err)
	}
	ecdsaKey, ecdsaKeyErr := jwt.ParseECPrivateKeyFromPEM(data)
	if ecdsaKeyErr != nil {
		log.Fatal("Error parsing private key: ", ecdsaKeyErr)
	}
	return ecdsaKey
}
