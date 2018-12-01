package main

import (
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"

	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"os"
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
		RedirectURL:  "http://localhost:" + port + "/auth",
		Scopes: []string{
			"https://www.googleapis.com/auth/userinfo.email",
			"https://www.googleapis.com/auth/userinfo.profile",
		},
		Endpoint: google.Endpoint,
	}
}

func main() {
	log.Println("Starting up http server on :" + port)

	http.Handle("/login", &loginHandler{})
	http.Handle("/auth", &authHandler{})
	http.ListenAndServe(":"+port, nil)
}
