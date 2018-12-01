package main

import (
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"

	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"
)

type Credentials struct {
	Cid     string `json:"client_id"`
	Csecret string `json:"client_secret"`
}

type User struct {
	Sub           string `json:"sub"`
	Name          string `json:"name"`
	GivenName     string `json:"given_name"`
	FamilyName    string `json:"family_name"`
	Profile       string `json:"profile"`
	Picture       string `json:"picture"`
	Email         string `json:"email"`
	EmailVerified string `json:"email_verified"`
	Gender        string `json:"gender"`
}

var cred Credentials
var conf *oauth2.Config
var port string

func randToken() string {
	b := make([]byte, 32)
	rand.Read(b)
	return base64.StdEncoding.EncodeToString(b)
}

func init() {
	port = os.Getenv("PORT")
	if port == "" {
		log.Fatal("PORT is not set, unable to start http server")
	}

	file, err := ioutil.ReadFile("./creds.json")
	if err != nil {
		log.Printf("File error: %v\n", err)
		os.Exit(1)
	}
	json.Unmarshal(file, &cred)

	conf = &oauth2.Config{
		ClientID:     cred.Cid,
		ClientSecret: cred.Csecret,
		RedirectURL:  "http://127.0.0.1:" + port + "/auth",
		Scopes: []string{
			"https://www.googleapis.com/auth/userinfo.email",
			"https://www.googleapis.com/auth/userinfo.profile",
		},
		Endpoint: google.Endpoint,
	}
}

func getLoginURL(state string) string {
	return conf.AuthCodeURL(state)
}

type authHandler struct{}

func (h *authHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	retrievedStateCookie, stateErr := r.Cookie("state")
	if retrievedStateCookie.Value == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("<html>Invalid state</html>"))
		return
	}
	if stateErr != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("<html>Invalid state</html>"))
		return
	}
	if retrievedStateCookie.Value != r.FormValue("state") {
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
	email, err := client.Get("https://www.googleapis.com/oauth2/v3/userinfo")
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(fmt.Sprintf("<html>Error: %v</html>", err)))
		return
	}
	defer email.Body.Close()
	data, _ := ioutil.ReadAll(email.Body)

	log.Println("Email body: ", string(data))

	w.Write([]byte("<html>OK</html>"))
}

type loginHandler struct{}

func (h *loginHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	state := randToken()
	expiration := time.Now().Add(365 * 24 * time.Hour)
	cookie := http.Cookie{Name: "state", Value: state, Expires: expiration}
	http.SetCookie(w, &cookie)
	w.Write([]byte("<html><title>Golang Google</title> <body> <a href='" + getLoginURL(state) + "'><button>Login with Google!</button> </a> </body></html>"))
}

func main() {
	log.Println("Starting up http server on :" + port)

	http.Handle("/login", &loginHandler{})
	http.Handle("/auth", &authHandler{})
	http.ListenAndServe(":"+port, nil)
}
