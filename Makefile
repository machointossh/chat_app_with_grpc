.PHONY: protoc m.start m.delete k8s.apply k8s.delete 

protoc:
	cd protoc && docker compose up

m.start:
	@bash scripts/minikube_start.sh

m.delete: k8s.delete
	@bash scripts/minikube_delete.sh

k8s.apply: m.start
	@bash scripts/k8s_apply.sh "chat-app"

k8s.delete:
	@bash scripts/k8s_delete.sh "chat-app"
