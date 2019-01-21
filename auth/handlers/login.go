package handlers

import (
	"golang.org/x/oauth2"

	"encoding/base64"
	"html/template"
	"log"
	"math/rand"
	"net/http"
	"time"
)

func randToken() string {
	b := make([]byte, 32)
	rand.Read(b)
	return base64.StdEncoding.EncodeToString(b)
}

type LoginHandler struct {
	Conf *oauth2.Config
}

func (h *LoginHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
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

	template, templateErr := template.New("login.html").ParseFiles("templates/login.html")
	if templateErr != nil {
		log.Fatal("Parse: ", templateErr)
		return
	}
	executeErr := template.Execute(w, h.Conf.AuthCodeURL(state))
	if executeErr != nil {
		log.Fatal("Execute: ", executeErr)
		return
	}
}
