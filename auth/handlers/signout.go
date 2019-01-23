package handlers

import (
	"net/http"
)

type SignoutHandler struct{}

func (h *SignoutHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	sessionCookie := http.Cookie{
		Name:     "home_session",
		Value:    "",
		MaxAge:   0,
		HttpOnly: false,
		Path:     "/",
	}
	http.SetCookie(w, &sessionCookie)

	http.Redirect(w, r, "/", 302)
}
