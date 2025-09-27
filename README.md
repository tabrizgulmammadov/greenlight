    # mac os/linux
    # export GREENLIGHT_DB_DSN='postgres://greenlight:pa55word@localhost/greenlight?sslmode=disable'
    # migrate create -seq -ext=.sql -dir=./migrations create_movies_table
    # migrate create -seq -ext=.sql -dir=./migrations add_movies_check_constraints
    # migrate -path=./migrations -database=$GREENLIGHT_DB_DSN up
    # migrate -path=./migrations -database=$GREENLIGHT_DB_DSN version
    # migrate -path=./migrations -database=$GREENLIGHT_DB_DSN goto 1
    # migrate -path=./migrations -database=$GREENLIGHT_DB_DSN down 1
    # migrate -path=./migrations -database=$EXAMPLE_DSN down -- down all migratins

    # windows
    # $env:GREENLIGHT_DB_DSN = "postgres://greenlight:pa55word@localhost/greenlight?sslmode=disable"
    # migrate create -seq -ext .sql -dir ./migrations create_movies_table
    # migrate create -seq -ext .sql -dir ./migrations add_movies_check_constraints
    # migrate -path ./migrations -database $env:GREENLIGHT_DB_DSN up
    # migrate -path ./migrations -database $env:GREENLIGHT_DB_DSN version
    # migrate -path ./migrations -database $env:GREENLIGHT_DB_DSN goto 1
    # migrate -path ./migrations -database $env:GREENLIGHT_DB_DSN down 1
    # migrate -path ./migrations -database $env:GREENLIGHT_DB_DSN down
