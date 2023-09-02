# Use an official Go runtime as the base image
FROM ubuntu:20.04 AS integration-test

# Set the working directory inside the container
WORKDIR /app

RUN apt-get update && apt-get install -y make
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    gcc \
    ca-certificates \
    && apt-get clean

# Download and install Go
RUN curl -LO https://golang.org/dl/go1.17.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz && \
    rm go1.17.linux-amd64.tar.gz

# Set environment variables for Go
ENV PATH="/usr/local/go/bin:$PATH"
ENV GOPATH="/go"
ENV GOBIN="/go/bin"

# Copy the source code into the container
COPY . .


# Run the tests
# ENTRYPOINT ["make test"]
RUN mkdir test-results
#
#to jest git	
# ENTRYPOINT ["/bin/bash", "-c", "set -o pipefail && go test -v ./... 2>&1 | tee /dev/tty > test-results/test.out"]

ENTRYPOINT [ "make test" ]


