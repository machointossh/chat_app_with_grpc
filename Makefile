.PHONY: protoc m.start m.delete k8s.apply k8s.delete 

protoc:
	cd protoc && docker compose up

m.start:
	@sh scripts/minikube_start.sh

m.delete: k8s.delete
	@sh scripts/minikube_delete.sh

k8s.apply: m.start
	@sh scripts/k8s_apply.sh "chat-app"

k8s.delete:
	@sh scripts/k8s_delete.sh "chat-app"

c.build:
	@sh scripts/client_operation.sh build

c.start:
	@sh scripts/client_operation.sh up

c.stop:
	docker-compose down
