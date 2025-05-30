# Better Next Docker

A production-ready, containerized full-stack TypeScript application built with modern technologies and optimized for Docker deployment. This project demonstrates best practices for containerizing Next.js and Hono applications in a monorepo setup.

This template is scaffolded by [Better-T Stack](https://better-t-stack.amanv.dev/), a modern CLI for scaffolding end-to-end type-safe TypeScript projects, built by [@amanvarshney01](https://x.com/amanvarshney01).

## 🐳 Docker-First Architecture

This repository is specifically designed for containerization and provides multiple deployment strategies:

- **Multi-stage Dockerfile** with optimized build targets
- **Docker Compose** configurations for development and production
- **Individual service containers** or **full-stack single container** options
- **Bun runtime** for improved performance and faster builds
- **Security-hardened** containers with non-root users

## 🚀 Technology Stack

### Frontend (Web App)
- **Next.js 15.3.0** - React framework with App Router
- **React 19** - Latest React with concurrent features
- **TypeScript 5** - Type safety and developer experience
- **TailwindCSS 4** - Utility-first CSS framework
- **shadcn/ui** - Modern, accessible UI components
- **Radix UI** - Headless UI primitives

### Backend (Server)
- **Hono 4.7.6** - Lightweight, fast web framework
- **Bun** - High-performance JavaScript runtime
- **TypeScript 5** - End-to-end type safety
- **Drizzle ORM 0.38.4** - TypeScript-first database toolkit
- **SQLite/Turso** - Embedded database with Turso cloud sync

### Full-Stack Integration
- **tRPC 11.0.0** - End-to-end typesafe APIs
- **TanStack Query 5.69.0** - Powerful data synchronization
- **Better Auth 1.2.7** - Modern authentication solution
- **AI SDK 4.3.16** - AI/ML integration capabilities

### Development & Build
- **Turborepo 2.4.2** - High-performance monorepo build system
- **Bun 1.2.15** - Package manager and runtime
- **ESLint & TypeScript** - Code quality and type checking

## 📦 Project Structure

```
better-next-docker/
├── apps/
│   ├── web/                # Next.js frontend application
│   │   ├── src/
│   │   │   ├── app/        # App Router pages and layouts
│   │   │   ├── components/ # Reusable UI components
│   │   │   └── lib/        # Utilities and configurations
│   │   └── package.json    # Frontend dependencies
│   └── server/             # Hono backend API
│       ├── src/
│       │   ├── db/         # Database schema and migrations
│       │   ├── lib/        # Server utilities
│       │   └── routers/    # tRPC router definitions
│       └── package.json    # Backend dependencies
├── packages/               # Shared packages (if any)
├── Dockerfile             # Multi-stage Docker build
├── docker-compose.yml     # Container orchestration
├── DOCKER.md             # Detailed Docker documentation
└── turbo.json            # Monorepo configuration
```

## 🐳 Docker Deployment Options

### Quick Start - Development
```bash
# Start development environment with hot reloading
docker-compose up dev
```

### Production Deployment

#### Option 1: Separate Services (Recommended)
```bash
# Run web and server as separate containers
docker-compose up --build web server
```

#### Option 2: Full-Stack Single Container
```bash
# Run both applications in one container
docker-compose up --build fullstack
```

#### Option 3: Individual Container Builds
```bash
# Build and run web application only
docker build --target web-runner -t better-next-docker-web .
docker run -p 3001:3001 better-next-docker-web

# Build and run server application only
docker build --target server-runner -t better-next-docker-server .
docker run -p 3000:3000 better-next-docker-server
```

## 🛠️ Local Development

### Prerequisites
- [Bun](https://bun.sh) (recommended) or Node.js 18+
- [Docker](https://docker.com) and Docker Compose

### Setup
```bash
# Clone the repository
git clone <repository-url>
cd better-next-docker

# Install dependencies
bun install

# Set up the database
cd apps/server && bun db:local

# Push database schema
bun db:push

# Start development servers
bun dev
```

### Available Scripts

| Script            | Description                                |
| ----------------- | ------------------------------------------ |
| `bun dev`         | Start all applications in development mode |
| `bun build`       | Build all applications for production      |
| `bun dev:web`     | Start only the frontend (port 3001)        |
| `bun dev:server`  | Start only the backend (port 3000)         |
| `bun check-types` | TypeScript type checking across all apps   |
| `bun db:push`     | Push database schema changes               |
| `bun db:studio`   | Open Drizzle Studio (database GUI)         |
| `bun db:generate` | Generate database migrations               |

## 🔧 Key Dependencies

### Frontend Dependencies
```json
{
  "next": "15.3.0",
  "react": "^19.0.0",
  "react-dom": "^19.0.0",
  "@trpc/client": "^11.0.0",
  "@trpc/tanstack-react-query": "^11.0.0",
  "@tanstack/react-query": "^5.69.0",
  "better-auth": "^1.2.7",
  "ai": "^4.3.16",
  "@ai-sdk/react": "^1.2.12",
  "tailwindcss": "^4",
  "@radix-ui/react-*": "^1.1.5+",
  "lucide-react": "^0.487.0",
  "zod": "^3.25.16"
}
```

### Backend Dependencies
```json
{
  "hono": "^4.7.6",
  "@hono/trpc-server": "^0.3.4",
  "@trpc/server": "^11.0.0",
  "drizzle-orm": "^0.38.4",
  "@libsql/client": "^0.14.0",
  "better-auth": "^1.2.7",
  "ai": "^4.3.16",
  "@ai-sdk/google": "^1.2.3",
  "zod": "^3.25.16"
}
```

## 🌐 Application URLs

- **Frontend (Web)**: http://localhost:3001
- **Backend (API)**: http://localhost:3000
- **Database Studio**: Available via `bun db:studio`

## 📚 Documentation

- [Docker Deployment Guide](./DOCKER.md) - Comprehensive Docker setup and deployment instructions
- [Better T-Stack](https://github.com/AmanVarshney01/create-better-t-stack) - Original stack template

## 🔒 Security Features

- Non-root user execution in all containers
- Multi-stage builds with minimal attack surface
- Environment-based configuration management
- Secure authentication with Better Auth
- Type-safe API contracts with tRPC

## 🚀 Performance Optimizations

- **Bun runtime** for faster JavaScript execution
- **Next.js standalone output** for minimal production bundles
- **Docker multi-stage builds** with optimized layer caching
- **Turborepo** for efficient monorepo builds
- **TanStack Query** for intelligent data caching

## 📝 Environment Configuration

Create `.env` files in the respective app directories:

```bash
# apps/server/.env
DATABASE_URL="file:local.db"
# Add your specific environment variables here
```

```bash
# apps/web/.env.local
NEXT_PUBLIC_API_URL="http://localhost:3000"
# Add your frontend environment variables here
```

## 🤝 Contributing

This project demonstrates containerization best practices. Feel free to use it as a reference for your own Docker deployments or contribute improvements to the containerization setup.

## 📄 License

This project was created with [Better-T-Stack](https://github.com/AmanVarshney01/create-better-t-stack) and optimized for Docker deployment.
