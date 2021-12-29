FROM golang:latest as build

WORKDIR /source

COPY . .

RUN go mod download

RUN go build -o /build/



FROM golang:latest as run

WORKDIR /app

COPY --from=build /build/* .

ENTRYPOINT ["/app/go-sample-app"]
