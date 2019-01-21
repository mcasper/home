package handlers

import (
	"golang.org/x/oauth2"

	"html/template"
	"log"
	"net/http"
	"time"
)

type UnauthorizedHandler struct {
	Conf *oauth2.Config
}

func (h *UnauthorizedHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	state := randToken()
	cookieExpiration := time.Now().Add(365 * 24 * time.Hour)
	stateCookie := http.Cookie{Name: "state", Value: state, Expires: cookieExpiration}
	http.SetCookie(w, &stateCookie)

	template, templateErr := template.New("unauthorized.html").ParseFiles("templates/unauthorized.html")
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
