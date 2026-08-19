FROM golang:1.26 AS builder
COPY ./ /go/src
WORKDIR /go/src
RUN go mod download && go build -o /bin/go-clamav .

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates
RUN groupadd -r app --gid=10001 && useradd -r -g app app --uid=10001
COPY --from=builder /bin/go-clamav /bin/go-clamav
USER app
ENTRYPOINT ["/bin/go-clamav"]
CMD ["poll"]