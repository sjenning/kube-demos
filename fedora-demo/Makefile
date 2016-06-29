all: build

build:
	docker build --tag master.turbot:5000/fedora:24-demo .

push: build
	docker push master.turbot:5000/fedora:24-demo
