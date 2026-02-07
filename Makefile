.PHONY: all init plan apply preflight deploy clean upgrade

all: apply deploy

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply -auto-approve

preflight:
	cd ansible && ansible-playbook preflight.yml

deploy: preflight
	cd ansible && ansible-playbook cluster.yml

clean:
	cd terraform && terraform destroy -auto-approve

upgrade:
	cd ansible && ansible-playbook upgrade.yml
