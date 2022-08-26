.DEFAULT_GOAL := help

tag := latest

define build_git_branch
	git checkout master
	git fetch
	git branch -D $(1) || true
	git checkout -b $(1)
	git commit -am "Re-create branch as $(1)" --allow-empty
	git push origin $(1) --force-with-lease
	git checkout master

endef

.PHONY: build
build: ## build tag
	$(call build_git_branch,$(tag))



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
