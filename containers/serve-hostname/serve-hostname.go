package main

import (
	"os"
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	hostname, err := os.Hostname()
	if err == nil {
		fmt.Fprintf(w, "%s\n", hostname)
	}
}

func main() {
	fmt.Println("Serving hostname on port 8080")
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
