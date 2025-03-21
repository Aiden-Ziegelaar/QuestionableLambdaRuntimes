build-buildimage:
	docker buildx build -t fortran-al2023:latest -f build.dockerfile . --progress=plain --platform linux/x86_64

build-function: build-buildimage
	docker run --platform linux/x86_64 --volume ./code:/code --volume ./scripts:/scripts  fortran-al2023:latest /bin/bash /scripts/build.sh

tf-init:
	terraform -chdir=./infra init

tf-plan:
	terraform -chdir=./infra plan

tf-apply:
	terraform -chdir=./infra apply --auto-approve

tf-destroy:
	terraform -chdir=./infra destroy --auto-approve
