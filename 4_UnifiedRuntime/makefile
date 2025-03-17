build-buildimage:
	docker buildx build -t ocaml-al2023:latest -f build.dockerfile . --progress=plain --platform linux/arm64

build-function: build-buildimage
	docker run --platform linux/arm64 --volume ./code:/code --volume ./scripts:/scripts ocaml-al2023:latest /bin/bash /scripts/build.sh

create-project: build-buildimage
	docker run --platform linux/arm64 --volume ./code:/code --volume ./scripts:/scripts ocaml-al2023:latest /bin/bash /scripts/create_project.sh

package-function: build-function
	rm -rf ./code/dist
	mkdir ./code/dist
	cp ./code/_build/default/bin/main.exe ./code/dist/bootstrap

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
