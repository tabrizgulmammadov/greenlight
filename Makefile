# Include variables from the .envrc file
include .envrc

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@powershell -Command " \
	  Get-Content '${MAKEFILE_LIST}' | \
	  Select-String '^##' | \
	  ForEach-Object { \
	    $$line = ($$_ -replace '^##', '').Trim(); \
	    if ($$line -match '^(.*?)\s*:\s*(.*)$$') { \
	      '{0,-28} {1}' -f $$matches[1], $$matches[2] \
	    } \
	  }"
#@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

.PHONY: confirm
confirm:
	@powershell -Command "$$ans = Read-Host 'Are you sure? [y/N]'; if ($$ans -ne 'y') { exit 1 }"

.PHONY: confirm/linux
confirm/linux:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

## run/api: run the cmd/api application
.PHONY: run/api
run/api:
	@echo 'Starting API...'
	go run ./cmd/api -db-dsn=${GREENLIGHT_DB_DSN} -jwt-secret=${JWT_SECRET}

## db/migrations/new name=$1: create a new database migration
.PHONY: db/migrations/new
db/migrations/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext .sql -dir ./migrations ${name}

## db/migrations/up: apply all up database migrations
.PHONY: db/migrations/up
db/migrations/up: confirm
	@echo 'Running up migrations...'
	migrate -path ./migrations -database ${GREENLIGHT_DB_DSN} up

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## tidy: tidy and vendor module dependencies, and format all .go files
.PHONY: tidy
tidy:
	@echo 'Tidying module dependencies...'
	go mod tidy
	@echo 'Verifying and vendoring module dependencies...'
	go mod verify
	go mod vendor
	@echo 'Formatting .go files...'
	go fmt ./...

## audit: run quality control checks
.PHONY: audit
audit:
	@echo 'Checking module dependencies...'
	go mod tidy -diff
	go mod verify
	@echo 'Vetting code...'
	go vet ./...
	go tool staticcheck ./...
	@echo 'Running tests...'
	go test -race -vet=off ./...

# ==================================================================================== #
# BUILD
# ==================================================================================== #

## build/api: build the cmd/api application
.PHONY: build/api
build/api:
	@echo Building cmd/api...
	go build -ldflags="-s" -o=bin/api.exe ./cmd/api
	@echo Building for Linux...
	@if not exist bin\linux_amd64 mkdir bin\linux_amd64
	set GOOS=linux&set GOARCH=amd64&go build -ldflags="-s" -o=bin/linux_amd64/api.exe ./cmd/api


.PHONY: build/api/linux
build/api/linux:
	@echo 'Building cmd/api...'
    go build -ldflags='-s' -o=./bin/api ./cmd/api
    GOOS=linux GOARCH=amd64 go build -ldflags='-s' -o=./bin/linux_amd64/api ./cmd/api
