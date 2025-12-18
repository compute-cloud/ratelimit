FROM 647619633241.dkr.ecr.us-east-1.amazonaws.com/imagefactory/go:1.25 AS build
WORKDIR /ratelimit

ENV GOPROXY=https://proxy.golang.org
COPY go.mod go.sum /ratelimit/
RUN go mod download

COPY src src
COPY script script

RUN CGO_ENABLED=0 GOOS=linux go build -o /go/bin/ratelimit -ldflags="-w -s" -v github.com/envoyproxy/ratelimit/src/service_cmd

FROM scratch
COPY --from=build /go/bin/ratelimit /bin/ratelimit
