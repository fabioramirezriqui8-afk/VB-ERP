#!/bin/bash
echo "Testing Login API..."
curl -s -X POST http://localhost:3000/api/v1/auth/login \
     -H "Content-Type: application/json" \
     -d '{
       "email": "admin@vb-erp.com",
       "password": "Admin1234!"
     }' | jq .
