#!/bin/bash
# test_all_identity.sh

BASE_URL="http://localhost:3000/api/v1"
EMAIL="admin@vb-erp.com"
PASSWORD="Admin1234!"

echo "--- 1. Login ---"
LOGIN_RES=$(curl -s -X POST "$BASE_URL/auth/login" \
     -H "Content-Type: application/json" \
     -d "{\"email\": \"$EMAIL\", \"password\": \"$PASSWORD\"}")

SUCCESS=$(echo $LOGIN_RES | jq -r '.success')
if [ "$SUCCESS" != "true" ]; then
    echo "Login failed: $LOGIN_RES"
    exit 1
fi

TOKEN=$(echo $LOGIN_RES | jq -r '.data.access_token')
REFRESH_TOKEN=$(echo $LOGIN_RES | jq -r '.data.refresh_token')

echo "Token obtained."

echo -e "\n--- 2. GET /me ---"
curl -s -X GET "$BASE_URL/me" -H "Authorization: Bearer $TOKEN" | jq .

echo -e "\n--- 3. GET /users ---"
curl -s -X GET "$BASE_URL/users" -H "Authorization: Bearer $TOKEN" | jq .

echo -e "\n--- 4. GET /roles ---"
curl -s -X GET "$BASE_URL/roles" -H "Authorization: Bearer $TOKEN" | jq .

echo -e "\n--- 5. GET /permissions ---"
curl -s -X GET "$BASE_URL/permissions" -H "Authorization: Bearer $TOKEN" | jq .

echo -e "\n--- 6. POST /auth/refresh ---"
curl -s -X POST "$BASE_URL/auth/refresh" \
     -H "Content-Type: application/json" \
     -d "{\"refresh_token\": \"$REFRESH_TOKEN\"}" | jq .

echo -e "\n--- 7. POST /auth/logout (Protected) ---"
curl -s -X POST "$BASE_URL/auth/logout" -H "Authorization: Bearer $TOKEN" | jq .
