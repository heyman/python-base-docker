build:
	docker build --platform linux/amd64 --no-cache -t heyman/python-base .

build_with_cache:
	docker build --platform linux/amd64 -t heyman/python-base .
