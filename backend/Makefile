# if deploy is explicitly provided, deploy only the provided functions
# ifeq (deploy,$(firstword $(MAKECMDGOALS)))
# SUBDIRS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
# SUBDIRS := $(patsubst %, src/%, $(SUBDIRS))
# $(eval $(SUBDIRS):;@:)
# endif

# ifeq ($(SUBDIRS),)
# $(shell echo $(SUBDIRS))
SUBDIRS := $(filter-out handlers,$(wildcard src/handlers/*))
BRANCH_NAME := $(shell git rev-parse --abbrev-ref HEAD)
# endif

build: $(SUBDIRS)

$(SUBDIRS):
	env GOARCH=amd64 GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -o bin/$(@F) $@/main.go

clean: 
	rm -rf ./bin

deploy: clean build
	gawk -i inplace -F ' ' '{if($$1=="service:"){print "service: trill-$(BRANCH_NAME)"} else if($$1=="basePath:"){print "    basePath: $(BRANCH_NAME)"} else {print $0}}' serverless.yml
	sls deploy --verbose
	gawk -i inplace -F ' ' '{if($$1=="service:"){print "service: trill-main"} else if($$1=="basePath:"){print "    basePath: main"} else {print $0}}' serverless.yml

remove: clean
	gawk -i inplace -F ' ' '{if($$1=="service:"){print "service: trill-$(BRANCH_NAME)"} else if($$1=="basePath:"){print "    basePath: $(BRANCH_NAME)"} else {print $0}}' serverless.yml
	sls remove --verbose
	gawk -i inplace -F ' ' '{if($$1=="service:"){print "service: trill-main"} else if($$1=="basePath:"){print "    basePath: main"} else {print $0}}' serverless.yml


.PHONY: build clean all $(SUBDIRS) deploy
.DEFAULT_GOAL := deploy