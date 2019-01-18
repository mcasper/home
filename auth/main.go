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
var google_creds_path string

func init() {
	port = os.Getenv("PORT")
	if port == "" {
		log.Fatal("PORT is not set, unable to start http server")
	}

	root_domain = os.Getenv("ROOT_DOMAIN")
	if root_domain == "" {
		log.Fatal("ROOT_DOMAIN is not set, unable to start http server")
	}

	google_creds_path = os.Getenv("GOOGLE_CREDS_PATH")
	if google_creds_path == "" {
		log.Fatal("GOOGLE_CREDS_PATH is not set, unable to start http server")
	}

	file, err := ioutil.ReadFile(google_creds_path)
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
	http.Handle("/auth/me", &meHandler{})
	log.Fatal(http.ListenAndServe(":"+port, logRequest(http.DefaultServeMux)))
}

func logRequest(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s %s\n", r.RemoteAddr, r.Method, r.URL)
		handler.ServeHTTP(w, r)
	})
}
