# Use an official Go runtime as the base image
FROM golang:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the source code into the container
COPY ../grpc_integeation .

# Run the tests
CMD ["go", "test", "-v", "./..."]
