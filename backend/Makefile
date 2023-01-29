# if deploy is explicitly provided, deploy only the provided functions
# ifeq (deploy,$(firstword $(MAKECMDGOALS)))
# SUBDIRS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
# SUBDIRS := $(patsubst %, src/%, $(SUBDIRS))
# $(eval $(SUBDIRS):;@:)
# endif

# ifeq ($(SUBDIRS),)
# $(shell echo $(SUBDIRS))
SUBDIRS := $(wildcard src/*)
# endif

build: $(SUBDIRS)

$(SUBDIRS):
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/$(@F) $@/main.go

clean: 
	rm -rf ./bin

deploy: clean build
	sls deploy --verbose --stage $(shell git rev-parse --abbrev-ref HEAD)

.PHONY: build clean all $(SUBDIRS) deploy
.DEFAULT_GOAL := deploy