# Use an official Go runtime as the base image
FROM golang:latest AS integration-test

# Set the working directory inside the container
WORKDIR /app
RUN echo "in test"
# Copy the source code into the container
COPY . .
WORKDIR /app/integration_test
# Run the tests
ENTRYPOINT ["go", "test", "-v", "./..."]

