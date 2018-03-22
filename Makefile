build:
	docker pull buildpack-deps:artful
	docker build --no-cache -t heyman/python-base .
