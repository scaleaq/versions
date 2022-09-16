docker_url := scaleaqcontainerregistry.azurecr.io
docker_username := scaleaqcontainerregistry
docker_password:=$(shell az acr credential show --name scaleaqcontainerregistry --query "passwords[0].value" --subscription 75c3a655-d005-4e4b-8716-e18571656da8)

update-smartspreader-api:
	@docker run --rm --net host -v regctl-conf:/home/appuser/.regctl/ regclient/regctl:latest registry login $(docker_url) -u $(docker_username) -p $(docker_password)
	$(eval tag := $(shell docker run --rm --net host -v regctl-conf:/home/appuser/.regctl/ regclient/regctl:latest tag ls scaleaqcontainerregistry.azurecr.io/smartspreader-api --limit 99999 | grep prod | sort -V -r | head -n 1))
	docker run --rm -v "$$PWD:$$PWD" -w="$$PWD" mikefarah/yq:4 -i '.services.api.image |= "scaleaqcontainerregistry.azurecr.io/smartspreader-api:$(tag)"' smartspreader.yaml

update-smartspreader-front-end:
	@docker run --rm --net host -v regctl-conf:/home/appuser/.regctl/ regclient/regctl:latest registry login $(docker_url) -u $(docker_username) -p $(docker_password)
	$(eval tag := $(shell docker run --rm --net host -v regctl-conf:/home/appuser/.regctl/ regclient/regctl:latest tag ls scaleaqcontainerregistry.azurecr.io/smartspreader-front-end --limit 99999 | grep prod | sort -V -r | head -n 1))
	docker run --rm -v "$$PWD:$$PWD" -w="$$PWD" mikefarah/yq:4 -i '.services.front-end.image |= "scaleaqcontainerregistry.azurecr.io/smartspreader-front-end:$(tag)"' smartspreader.yaml

update-smartspreader: update-smartspreader-api update-smartspreader-front-end

