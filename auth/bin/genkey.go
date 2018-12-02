package main

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"io/ioutil"
)

func main() {
	privateKey, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		panic(err)
	}

	privB, _ := x509.MarshalECPrivateKey(privateKey)
	privBytes := pem.EncodeToMemory(
		&pem.Block{
			Type:  "EC PRIVATE KEY",
			Bytes: privB,
		},
	)

	pubB, _ := x509.MarshalPKIXPublicKey(&privateKey.PublicKey)
	pubBytes := pem.EncodeToMemory(&pem.Block{
		Type:  "EC PUBLIC KEY",
		Bytes: pubB,
	})

	ioutil.WriteFile("key.pem", privBytes, 0644)
	ioutil.WriteFile("key.pem.pub", pubBytes, 0644)
	fmt.Println("Written private and public keys")
}
