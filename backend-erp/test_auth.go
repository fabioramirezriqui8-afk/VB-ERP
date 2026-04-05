package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/lib/pq"
	"golang.org/x/crypto/bcrypt"
)

func main() {
	connStr := "host=localhost port=5432 user=postgres password=postgres dbname=vb_erp sslmode=disable"
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Error opening db: %v", err)
	}
	defer db.Close()

	var passwordHash string
	email := "admin@vb-erp.com"
	err = db.QueryRow("SELECT password FROM users WHERE email = $1", email).Scan(&passwordHash)
	if err != nil {
		log.Fatalf("Error fetching user: %v", err)
	}

	fmt.Printf("User: %s\n", email)
	fmt.Printf("Hash in DB: %s\n", passwordHash)

	testPasswords := []string{"Admin1234!", "password", "admin", "123456"}
	for _, p := range testPasswords {
		err := bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(p))
		if err == nil {
			fmt.Printf("✅ MATCH FOUND for password: '%s'\n", p)
		} else {
			fmt.Printf("❌ NO MATCH for password: '%s' (Error: %v)\n", p, err)
		}
	}
}
