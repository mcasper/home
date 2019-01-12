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

var cred Credentials
var conf *oauth2.Config
var port string
var root_domain string

func init() {
	port = os.Getenv("PORT")
	if port == "" {
		log.Fatal("PORT is not set, unable to start http server")
	}

	root_domain = os.Getenv("ROOT_DOMAIN")
	if root_domain == "" {
		log.Fatal("ROOT_DOMAIN is not set, unable to start http server")
	}

	file, err := ioutil.ReadFile("./creds.json")
	if err != nil {
		log.Fatalf("File error: %v\n", err)
	}
	json.Unmarshal(file, &cred)

	conf = &oauth2.Config{
		ClientID:     cred.Cid,
		ClientSecret: cred.Csecret,
		RedirectURL:  root_domain + "/auth/consume",
		Scopes: []string{
			"https://www.googleapis.com/auth/userinfo.email",
			"https://www.googleapis.com/auth/userinfo.profile",
		},
		Endpoint: google.Endpoint,
	}
}

func main() {
	log.Println("Starting up http server on :" + port)

	http.Handle("/auth/login", &loginHandler{})
	http.Handle("/auth", &loginHandler{})
	http.Handle("/auth/consume", &authHandler{})
	http.ListenAndServe(":"+port, nil)
}
