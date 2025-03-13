build-buildimage:
	docker buildx build -t gnucobol-fedora:latest -f build.dockerfile . --progress=plain --platform linux/amd64

build-function: build-buildimage
	docker run --platform linux/amd64 --volume ./code:/code  gnucobol-fedora:latest /bin/bash /code/scripts/build.sh

build-runimage: build-function
	docker buildx build -t cobol_library_runtime:latest -f run.dockerfile . --progress=plain --platform linux/amd64

push-runimage: build-runimage
	docker tag cobol_library_runtime:latest 975050098174.dkr.ecr.ap-southeast-2.amazonaws.com/cobol_library_runtime:latest
	docker push 975050098174.dkr.ecr.ap-southeast-2.amazonaws.com/cobol_library_runtime:latest

tf-init:
	terraform -chdir=./infra init

tf-plan:
	terraform -chdir=./infra plan

tf-replace-lambda:
	terraform -chdir=./infra apply -replace=lambda.aws_lambda_function[\"lambda\"] --auto-approve 

tf-apply:
	terraform -chdir=./infra apply --auto-approve

tf-destroy:
	terraform -chdir=./infra destroy --auto-approve
