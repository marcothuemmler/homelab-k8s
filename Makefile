.PHONY: all init plan apply deploy clean

all: apply deploy

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply -auto-approve

deploy:
	cd ansible && ansible-playbook cluster.yml

clean:
	cd terraform && terraform destroy -auto-approve