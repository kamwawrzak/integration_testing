DB_NAME = mydatabase
DB_USER = myuser
DB_PASSWORD = mypassword

# Create the MySQL database
create-db:
	docker exec -it my-mysql mysql -u root -p$(DB_PASSWORD) -e "CREATE DATABASE $(DB_NAME)"

# Start the MySQL database
start-db:
	docker run --name my-mysql --network my-network -e MYSQL_ROOT_PASSWORD=$(DB_PASSWORD) -p 3306:3306 -d mysql:latest

# Stop the MySQL database
stop-db:
	docker stop my-mysql
	docker rm my-mysql
	
up: start-db create-db

# Build the project
build:
	go build -o my-app ./cmd/my-app

# Run the application
run:
	go run ./cmd/my-app/main.go

# Clean build artifacts
clean:
	rm -f my-app

# Run tests
test:
	mkdir test-results
	go test -v ./... > test-results/results.txt

# Default target
.DEFAULT_GOAL := run
