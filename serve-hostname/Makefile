all: serve-hostname

serve-hostname:
	CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' serve-hostname.go

clean:
	rm -f serve-hostname

push:
	docker build --tag master.turbot:5000/serve-hostname:latest . && docker push master.turbot:5000/serve-hostname:latest
