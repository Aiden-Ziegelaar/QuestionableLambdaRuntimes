build-buildimage:
	docker buildx build -t cargo-lambda:latest -f build.dockerfile . --progress=plain --platform linux/amd64

build-function: build-buildimage
	docker run --platform linux/amd64 --volume ./code:/code --volume ./scripts:/scripts  cargo-lambda:latest /bin/bash /scripts/build.sh

tf-init:
	terraform -chdir=./infra init

tf-plan:
	terraform -chdir=./infra plan

tf-apply:
	terraform -chdir=./infra apply --auto-approve

tf-destroy:
	terraform -chdir=./infra destroy --auto-approve
