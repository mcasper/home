package handlers

import (
	"github.com/mcasper/home/auth/token"
	"golang.org/x/oauth2"

	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

type AuthHandler struct {
	Conf *oauth2.Config
}

func (h *AuthHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
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
		fmt.Println("heyheyhey")
		fmt.Println(returnToErr)
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("<html>Invalid returnTo</html>"))
		return
	}
	if retrievedReturnToCookie.Value == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("<html>Invalid state</html>"))
		return
	}

	tok, err := h.Conf.Exchange(oauth2.NoContext, r.FormValue("code"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(fmt.Sprintf("<html>Error: %v</html>", err)))
		return
	}

	client := h.Conf.Client(oauth2.NoContext, tok)
	profileHandle, err := client.Get("https://www.googleapis.com/oauth2/v3/userinfo")
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(fmt.Sprintf("<html>Error: %v</html>", err)))
		return
	}
	defer profileHandle.Body.Close()
	profileInfoJson, _ := ioutil.ReadAll(profileHandle.Body)
	var profileInfo token.ProfileInfo
	json.Unmarshal(profileInfoJson, &profileInfo)

	if !whitelistedEmail(profileInfo.Email) {
		http.Redirect(w, r, "/auth/unauthorized", 302)
		return
	}

	jwt, jwtErr := token.NewToken(profileInfo)
	if jwtErr != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(fmt.Sprintf("<html>Error: %v</html>", jwtErr)))
		return
	}
	redirectTo := retrievedReturnToCookie.Value + "?key=" + jwt

	cookieExpiration := time.Now().Add(24 * time.Hour)
	sessionCookie := http.Cookie{
		Name:    "home_session",
		Value:   jwt,
		Expires: cookieExpiration,
		// Secure:   true,
		HttpOnly: false,
		Path:     "/",
	}
	http.SetCookie(w, &sessionCookie)

	http.Redirect(w, r, redirectTo, 302)
}

func whitelistedEmail(email string) bool {
	return contains(emailWhitelist(), email)
}

func emailWhitelist() []string {
	return []string{
		"matthewvcasper@gmail.com",
		"ashlynccasper@gmail.com",
	}
}

func contains(s []string, e string) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}
