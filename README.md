# Greenlight API

A JSON API for retrieving and managing information about movies, built with Go following best practices and clean architecture principles.

## Features

- RESTful JSON API for movie management
- User authentication and authorization
- Token-based authentication (activation and password reset)
- Permission-based access control
- Email notifications
- CORS support
- Rate limiting
- Database migrations
- Graceful shutdown
- Health check endpoint

## Project Structure

```
greenlight/
├── cmd/
│   ├── api/              # Main application code
│   │   ├── main.go       # Application entry point
│   │   ├── routes.go     # Route definitions
│   │   ├── middleware.go # HTTP middleware
│   │   ├── movies.go     # Movie handlers
│   │   ├── users.go      # User handlers
│   │   ├── tokens.go     # Token handlers
│   │   ├── helpers.go    # Helper functions
│   │   ├── errors.go     # Error handling
│   │   ├── context.go    # Context helpers
│   │   ├── server.go     # HTTP server
│   │   └── healthcheck.go # Health check handler
│   └── examples/         # Example applications (CORS demos)
│       └── cors/
│           ├── simple/
│           └── preflight/
├── internal/
│   ├── data/            # Data models and database logic
│   │   ├── models.go    # Model definitions
│   │   ├── movies.go    # Movie model
│   │   ├── users.go     # User model
│   │   ├── tokens.go    # Token model
│   │   ├── permissions.go # Permission model
│   │   ├── filters.go   # Query filters
│   │   └── runtime.go   # Runtime type
│   ├── mailer/          # Email sending functionality
│   │   ├── mailer.go
│   │   └── templates/   # Email templates
│   │       ├── user_welcome.tmpl
│   │       ├── token_activation.tmpl
│   │       └── token_password_reset.tmpl
│   ├── validator/       # Input validation
│   │   └── validator.go
│   └── vcs/             # Version control information
│       └── vcs.go
├── migrations/          # Database migration files
│   ├── 000001_create_movies_table.up.sql
│   ├── 000001_create_movies_table.down.sql
│   ├── 000002_add_movies_check_constraints.up.sql
│   ├── 000002_add_movies_check_constraints.down.sql
│   ├── 000003_add_movies_indexes.up.sql
│   ├── 000003_add_movies_indexes.down.sql
│   ├── 000004_create_users_table.up.sql
│   ├── 000004_create_users_table.down.sql
│   ├── 000005_create_tokens_table.up.sql
│   ├── 000005_create_tokens_table.down.sql
│   ├── 000006_add_permissions.up.sql
│   └── 000006_add_permissions.down.sql
├── .envrc              # Environment variables
├── .gitignore          # Git ignore rules
├── go.mod              # Go module definition
├── go.sum              # Go module checksums
├── Makefile            # Build and development tasks
└── README.md           # This file
```

## Prerequisites

- Go 1.21 or higher
- PostgreSQL 12 or higher
- Make (for running Makefile commands)
- migrate CLI tool (for database migrations)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/tabrizgulmammadov/greenlight.git
cd greenlight
```

2. Copy the environment configuration:
```bash
cp .envrc.example .envrc
```

3. Update `.envrc` with your configuration:
```bash
export GREENLIGHT_DB_DSN='postgres://username:password@localhost/greenlight?sslmode=disable'
export JWT_SECRET=<secret-token>
```

4. Load environment variables:
```bash
source .envrc
```

5. Install dependencies:
```bash
go mod download
```

6. Run database migrations:
```bash
make db/migrations/up
```

## Building

### Build for current platform (Windows):
```bash
make build/api
```
This creates `bin/api.exe`

### Build for Linux (from Windows):
```bash
make build/api/linux
```
This creates `bin/linux_amd64/api`

### Build both:
```bash
make build/api
```

The binaries will be created in the `bin/` directory.

## Running

### Development mode:
```bash
make run/api
```

### Production mode (Windows):
```bash
./bin/api.exe -port=4000
```

### Production mode (Linux):
```bash
./bin/linux_amd64/api -port=4000
```

## Configuration

### Command-Line Flags

| Flag | Environment Variable | Default | Description |
|------|---------------------|---------|-------------|
| `-port` | `GREENLIGHT_PORT` | `4000` | API server port |
| `-env` | `GREENLIGHT_ENV` | `development` | Environment (development\|staging\|production) |
| `-db-dsn` | `GREENLIGHT_DB_DSN` | - | PostgreSQL connection string (DSN) |
| `-db-max-open-conns` | `GREENLIGHT_DB_MAX_OPEN_CONNS` | `25` | Maximum number of open database connections |
| `-db-max-idle-conns` | `GREENLIGHT_DB_MAX_IDLE_CONNS` | `25` | Maximum number of idle database connections |
| `-db-max-idle-time` | `GREENLIGHT_DB_MAX_IDLE_TIME` | `15m` | Maximum database connection idle time |
| `-limiter-rps` | `GREENLIGHT_LIMITER_RPS` | `2` | Rate limiter maximum requests per second |
| `-limiter-burst` | `GREENLIGHT_LIMITER_BURST` | `4` | Rate limiter maximum burst size |
| `-limiter-enabled` | `GREENLIGHT_LIMITER_ENABLED` | `true` | Enable/disable rate limiting |
| `-smtp-host` | `GREENLIGHT_SMTP_HOST` | `sandbox.smtp.mailtrap.io` | SMTP server hostname |
| `-smtp-port` | `GREENLIGHT_SMTP_PORT` | `2525` | SMTP server port |
| `-smtp-username` | `GREENLIGHT_SMTP_USERNAME` | `baf3c30dbc8dd5` | SMTP authentication username |
| `-smtp-password` | `GREENLIGHT_SMTP_PASSWORD` | `e26985c8241c05` | SMTP authentication password |
| `-smtp-sender` | `GREENLIGHT_SMTP_SENDER` | `Greenlight <no-reply@tabrizgulmammadov.com>` | Email sender address |
| `-cors-trusted-origins` | `GREENLIGHT_CORS_TRUSTED_ORIGINS` | - | Trusted CORS origins (space-separated) |
| `-jwt-secret` | `GREENLIGHT_JWT_SECRET` | - | JWT signing secret key |
| `-version` | - | `false` | Display version information and exit |

### Configuration Examples

#### Using Command-Line Flags:
```bash

### Example:
```bash
./bin/api.exe \
  -port=4000 \
  -env=production \
  -db-dsn=$GREENLIGHT_DB_DSN \
  -smtp-host=$GREENLIGHT_SMTP_HOST \
  -smtp-port=$GREENLIGHT_SMTP_PORT \
  -smtp-username=$GREENLIGHT_SMTP_USERNAME \
  -smtp-password=$GREENLIGHT_SMTP_PASSWORD \
  -smtp-sender=$GREENLIGHT_SMTP_SENDER \
  -cors-trusted-origins="https://example.com https://app.example.com"
```

## API Endpoints

### Health Check
- `GET /v1/healthcheck` - API health status

### Users
- `POST /v1/users` - Register new user
- `PUT /v1/users/activated` - Activate user account

### Authentication
- `POST /v1/tokens/authentication` - Create authentication token (login)
- `POST /v1/tokens/password-reset` - Request password reset token

### Movies (require authentication)
- `GET /v1/movies` - List movies with filtering, sorting, and pagination
- `POST /v1/movies` - Create new movie (requires `movies:write` permission)
- `GET /v1/movies/:id` - Get movie by ID (requires `movies:read` permission)
- `PATCH /v1/movies/:id` - Update movie (requires `movies:write` permission)
- `DELETE /v1/movies/:id` - Delete movie (requires `movies:write` permission)

## API Usage Examples

### Register a new user:
```bash
curl -X POST http://localhost:4000/v1/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "pa55word"
  }'
```

### Activate user account:
```bash
curl -X PUT http://localhost:4000/v1/users/activated \
  -H "Content-Type: application/json" \
  -d '{
    "token": "ACTIVATION_TOKEN_FROM_EMAIL"
  }'
```

### Authenticate (login):
```bash
curl -X POST http://localhost:4000/v1/tokens/authentication \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "pa55word"
  }'
```

### List movies:
```bash
curl http://localhost:4000/v1/movies \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"
```

### List movies with filters:
```bash
curl "http://localhost:4000/v1/movies?title=godfather&genres=crime,drama&page=1&page_size=5&sort=-year" \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"
```

### Create a movie:
```bash
curl -X POST http://localhost:4000/v1/movies \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "The Matrix",
    "year": 1999,
    "runtime": "136 mins",
    "genres": ["sci-fi", "action"]
  }'
```

### Get a movie:
```bash
curl http://localhost:4000/v1/movies/1 \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"
```

### Update a movie:
```bash
curl -X PATCH http://localhost:4000/v1/movies/1 \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "year": 1999,
    "runtime": "136 mins"
  }'
```

### Delete a movie:
```bash
curl -X DELETE http://localhost:4000/v1/movies/1 \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"
```

## Authentication

The API uses token-based authentication:

1. Register a user account via `POST /v1/users`
2. Activate the account using the token sent via email to `PUT /v1/users/activated`
3. Authenticate via `POST /v1/tokens/authentication` to receive an authentication token
4. Include the token in the `Authorization` header for protected endpoints:
   ```
   Authorization: Bearer <your-token>
   ```

Authentication tokens are valid for 24 hours.

## Permissions

The API implements a role-based permission system:

- `movies:read` - Read movie information
- `movies:write` - Create, update, and delete movies

Permissions are assigned to users when they register. By default, new users receive the `movies:read` permission.

## Rate Limiting

The API implements rate limiting to prevent abuse:

- Default: 2 requests per second with burst of 4
- Applied per IP address
- Returns `429 Too Many Requests` when limit exceeded
- Can be disabled or configured via command-line flags

Rate limit headers are included in responses:
- `X-RateLimit-Limit` - Requests per second allowed
- `X-RateLimit-Remaining` - Requests remaining in current window
- `X-RateLimit-Reset` - Time when rate limit resets

## CORS

Cross-Origin Resource Sharing (CORS) is supported for browser-based clients.

Configure trusted origins via:
- Command-line flag: `-cors-trusted-origins="https://example.com https://app.example.com"`
- Environment variable: `GREENLIGHT_CORS_TRUSTED_ORIGINS`

The API supports both simple and preflight CORS requests.

## Database Migrations

### View migration status:
```bash
make db/migrations/status
```

### Create new migration:
```bash
make db/migrations/new name=add_new_field
```

### Apply all pending migrations:
```bash
make db/migrations/up
```

### Rollback last migration:
```bash
make db/migrations/down
```

## Email Templates

Email templates are located in `internal/mailer/templates/` and use Go's `html/template` package:

- `user_welcome.tmpl` - Welcome email for new users
- `token_activation.tmpl` - Account activation email with token
- `token_password_reset.tmpl` - Password reset email with token

To customize emails, edit these template files.

## Development

### View available make commands:
```bash
make help
```

### Run the application in development mode:
```bash
make run/api
```

### Run tests:
```bash
go test ./...
```

### Format code:
```bash
go fmt ./...
```

### Tidy dependencies:
```bash
go mod tidy
```

## Deployment

### Build for production:
```bash
make build/api/linux
```

### Run in production:
```bash
./bin/linux_amd64/api \
  -port=4000 \
  -env=production \
  -db-dsn=$DATABASE_URL \
  -smtp-host=$SMTP_HOST \
  -smtp-port=$SMTP_PORT \
  -smtp-username=$SMTP_USERNAME \
  -smtp-password=$SMTP_PASSWORD \
  -smtp-sender=$SMTP_SENDER
```

### Graceful shutdown:
The application supports graceful shutdown. Send `SIGINT` (Ctrl+C) or `SIGTERM` signal:
- Stops accepting new requests
- Waits for existing requests to complete (max 20 seconds)
- Closes database connections
- Exits cleanly

## Troubleshooting

### Database connection errors:
- Verify PostgreSQL is running
- Check DSN connection string
- Ensure database exists: `createdb greenlight`
- Verify user has proper permissions

### Migration errors:
- Check migration files are in `migrations/` directory
- Verify database connectivity
- Check migration version in database: `SELECT * FROM schema_migrations;`

### Email sending errors:
- Verify SMTP credentials
- Check SMTP host and port
- Test with a development SMTP service like Mailtrap

### Rate limiting issues:
- Disable rate limiting for testing: `-limiter-enabled=false`
- Adjust rate limits: `-limiter-rps=10 -limiter-burst=20`

## Technology Stack

- **Language**: Go 1.21+
- **Database**: PostgreSQL 12+
- **Migrations**: golang-migrate
- **Email**: SMTP with html/template
- **HTTP Router**: httprouter
- **Validation**: Custom validator package
- **Password Hashing**: bcrypt

## Authors

- Tabriz Gulmammadov - [gulmammadovtabriz@gmail.com](mailto:gulmammadovtabriz@gmail.com)

## Acknowledgments

- Based on "Let's Go Further" by Alex Edwards
- Built following Go best practices and clean architecture principles