DB_NAME = mydatabase
DB_USER = myuser
DB_PASSWORD = mypassword
SHELL=/bin/bash -o pipefail

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
#to jest git
testt:
	mkdir test-results
	/bin/bash -o pipefail -c go test -v ./... 2>&1 | tee > test-results/test.out
test:
	mkdir test-results
	go test -v ./... 2>&1 | tee > test-results/test.out

install-junitor:
	go get github.com/jstemmer/go-junit-report
	go install github.com/jstemmer/go-junit-report

# Default target
.DEFAULT_GOAL := run
