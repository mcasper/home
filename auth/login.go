package main

import (
	"encoding/base64"
	"math/rand"
	"net/http"
	"time"
)

func getLoginURL(state string) string {
	return conf.AuthCodeURL(state)
}

func randToken() string {
	b := make([]byte, 32)
	rand.Read(b)
	return base64.StdEncoding.EncodeToString(b)
}

type loginHandler struct{}

func (h *loginHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	returnTo := r.FormValue("returnTo")
	if returnTo == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("<html>No returnTo</html>"))
		return
	}

	state := randToken()
	cookieExpiration := time.Now().Add(365 * 24 * time.Hour)
	stateCookie := http.Cookie{Name: "state", Value: state, Expires: cookieExpiration}
	returnToCookie := http.Cookie{Name: "returnTo", Value: returnTo, Expires: cookieExpiration}
	http.SetCookie(w, &stateCookie)
	http.SetCookie(w, &returnToCookie)

	w.Write([]byte("<html><title>Golang Google</title> <body> <a href='" + getLoginURL(state) + "'><button>Login with Google!</button> </a> </body></html>"))
}
