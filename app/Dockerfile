FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod ./
COPY main.go ./
RUN go build -o app .

FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/app /app/app
CMD ["/app/app"]
