# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

Two independent sub-projects under one root:

- `onlineshopapi/` — Spring Boot 4 / Java 21 REST API (Maven)
- `onlineshopui/` — Angular 21 SPA (npm)
- `docker/development/` — Docker Compose file for local PostgreSQL

## Development Setup

### 1. Database (required for backend)

```bash
cd docker/development
docker-compose up
```

Starts PostgreSQL 18 on port **5433**: database `shopdb`, user `shopuser`, password `shoppassword`.

### 2. Backend

```bash
cd onlineshopapi
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

Runs on `http://localhost:3000/api`. The `local` profile activates `application-local.yml` (hardcoded dev credentials, port 5433) and includes the `db/migration/local` Flyway path which seeds mock users and products.

Swagger UI: `http://localhost:3000/api/swagger-ui/index.html`

#### Backend commands

```bash
mvn clean package          # build JAR
mvn test                   # run all tests
mvn test -Dtest=ClassName  # run a single test class
```

### 3. Frontend

```bash
cd onlineshopui
npm install
npm start             # dev server at http://localhost:4200 (connects to real API)
npm run start:mock    # dev server with mock backend (no API needed)
```

#### Frontend commands

```bash
npm run build         # production bundle
npm test              # Vitest unit tests
npm run lint          # ESLint
npm run format        # Prettier (writes files)
```

## Architecture

### Backend (`onlineshopapi`)

Standard Spring Boot layered architecture: `controller → service → repository → model`.

**Key packages:**

- `security/` — Stateless JWT auth. `JwtAuthFilter` validates bearer tokens on every request; `SecurityConfig` permits only `/auth/register`, `/auth/login`, and Swagger endpoints without a token. Role-based access is enforced at the method level via `@EnableMethodSecurity`.
- `service/strategy/` — Order fulfillment Strategy pattern. `OrderStrategyConfig` reads `app.order.strategy` (enum: `SINGLE_LOCATION` | `MOST_ABUNDANT`) and wires the correct `OrderStrategy` bean. The default is `SINGLE_LOCATION`.
- `model/` — JPA entities with two composite-key entities: `Stock` (`product_id + location_id`) and `OrderDetail` (`order_id + product_id`).

**Database migrations** live in `src/main/resources/db/migration/`. The `local` Flyway location (`db/migration/local`) adds seed data only when running with the `local` profile.

**Production** requires env vars: `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD`, `JWT_SECRET`, `CORS_ALLOWED_ORIGINS`.

**Testing** uses `@WebMvcTest` (controller slice tests with `MockMvc`) and `@SpringBootTest` + Testcontainers (integration tests against a real PostgreSQL container). `TestSecurityConfig` provides a test-specific security setup.

### Frontend (`onlineshopui`)

Angular 21 standalone-components architecture with lazy-loaded feature modules.

**Feature modules** under `src/app/features/`: `auth`, `products`, `cart`, `orders`. Each has its own `*.routes.ts`, `services/`, `components/` (split into `pages/` and `views/`), and `types/`.

**Core cross-cutting concerns** under `src/app/core/`:

- `config/constants/` — navigation routes, icon registry, validation messages
- `providers/` — `provideEnvironmentConfiguration`, `provideValidationMessages`, `getMockInterceptors`
- `mocks/` — HTTP interceptors that simulate the full API for the `mock` environment

**App bootstrap** (`app.config.ts`): on init, `AuthService.loadProfileIfNeeded()` runs before navigation (`withEnabledBlockingInitialNavigation`). Route params are bound directly to component inputs (`withComponentInputBinding`).

**Guards:**

- `authGuard` — redirects unauthenticated users to `/auth/login`
- `guestGuard` — redirects already-authenticated users away from auth pages
- `rolesGuard` — checks `route.data.roles` against the current user's role; redirects to the product catalog on failure

**HTTP interceptors:**

- `authTokenInterceptor` — attaches `Authorization: Bearer <token>` to every outbound request
- Mock interceptors — active only in the `mock` environment; registered conditionally in `app.config.ts`

**Environments** (`src/environments/`): `development` (real API at `localhost:3000/api`), `mock` (intercepts requests client-side), `production` (reads `API_URL` from env at build time).

### Mock users (local profile)

| Email | Role | Password |
|---|---|---|
| `admin@onlineshop.com` | ADMIN | `password` |
| `john.doe@email.com` | CUSTOMER | `password` |
| `jane.smith@email.com` | CUSTOMER | `password` |
