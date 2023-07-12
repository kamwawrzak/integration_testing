# Use an official Go runtime as the base image
FROM golang:latest AS integration-test

# Set the working directory inside the container
WORKDIR /app

# Copy the source code into the container
COPY . .


# Run the tests
ENTRYPOINT ["make", "test"]

