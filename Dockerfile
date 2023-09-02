# Use an official Go runtime as the base image
FROM ubuntu:20.04 AS integration-test

# Set the working directory inside the container
WORKDIR /app

RUN apt-get update && apt-get install -y make


# Copy the source code into the container
COPY . .


# Run the tests
# ENTRYPOINT ["make test"]
RUN mkdir test-results
	
CMD ["/bin/bash", "-c", "set -o pipefail && go test -v ./... 2>&1 | tee /dev/tty > test-results/test.out"]


