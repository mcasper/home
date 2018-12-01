package main

import (
	"golang.org/x/oauth2"

	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

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
	profileInfo, _ := ioutil.ReadAll(profileHandle.Body)
	log.Printf("%s\n", profileInfo)

	http.Redirect(w, r, retrievedReturnToCookie.Value, 302)

	w.Write([]byte("<html>OK</html>"))
}
