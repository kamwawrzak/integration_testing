# Use an official Go runtime as the base image
FROM golang:latest AS integration-test

# Set the working directory inside the container
WORKDIR /app
RUN echo "in test"
# Copy the source code into the container
COPY . .

# Run the tests
ENTRYPOINT ["go", "test", "-v", "./..."]

FROM golang:latest AS build

# Set the working directory inside the container
WORKDIR /app
RUN echo "in build"
# Copy the source code into the container
COPY . .

# Run the tests
ENTRYPOINT ["go", "build"]
