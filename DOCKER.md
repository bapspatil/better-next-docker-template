# Docker Deployment Guide

This project includes multiple Docker configurations for different deployment scenarios.

## Available Docker Configurations

### 1. Individual Application Dockerfiles

#### Web Application (`apps/web/Dockerfile`)
Builds only the Next.js web application with standalone output.

```bash
# Build web app only
docker build -f apps/web/Dockerfile -t better-next-docker-web .

# Run web app
docker run -p 3001:3001 better-next-docker-web
```

#### Server Application (`apps/server/Dockerfile`)
Builds only the Bun-based server application.

```bash
# Build server only
docker build -f apps/server/Dockerfile -t better-next-docker-server .

# Run server
docker run -p 3000:3000 better-next-docker-server
```

### 2. Multi-Stage Root Dockerfile

The root `Dockerfile` provides multiple build targets:

#### Build Web Application Only
```bash
docker build --target web-runner -t better-next-docker-web .
docker run -p 3001:3001 better-next-docker-web
```

#### Build Server Application Only
```bash
docker build --target server-runner -t better-next-docker-server .
docker run -p 3000:3000 better-next-docker-server
```

#### Build Full-Stack Application (Both Web + Server)
```bash
docker build --target fullstack -t better-next-docker-fullstack .
docker run -p 3001:3001 -p 3000:3000 better-next-docker-fullstack
```

## Docker Compose Configurations

### Development Mode
Run with hot reloading and development features:

```bash
docker-compose up dev
```

This will:
- Mount your source code for hot reloading
- Run on ports 3001 (web) and 3000 (server)
- Enable development environment

### Production - Separate Services
Run web and server as separate containers:

```bash
# Run both services
docker-compose up web server

# Or run individually
docker-compose up web
docker-compose up server
```

### Production - Full-Stack Single Container
Run both applications in a single container:

```bash
docker-compose up fullstack
```

## Environment Variables

Make sure to set the following environment variables for production:

```bash
# .env.production
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1

# Add your specific environment variables here
# DATABASE_URL=your_database_url
# API_KEY=your_api_key
```

## Build Optimization Features

### Multi-Stage Builds
- Separate dependency installation stage for better caching
- Optimized production images with minimal layers
- Non-root user execution for security

### Bun Package Manager
- Fast dependency installation with `bun install --frozen-lockfile`
- Efficient JavaScript runtime for both build and production
- Better performance compared to npm/yarn

### Next.js Standalone Output
- Minimal production bundle with only necessary files
- Self-contained server with output file tracing
- Reduced image size and faster startup times

## Quick Start Commands

### For Development
```bash
# Start development environment
docker-compose up dev
```

### For Production Deployment
```bash
# Build and run full-stack application
docker-compose up --build fullstack

# Or run separate services
docker-compose up --build web server
```

### Building Individual Images
```bash
# Build all targets
docker build -t better-next-docker .

# Build specific target
docker build --target web-runner -t better-next-docker-web .
docker build --target server-runner -t better-next-docker-server .
```

## Port Configuration

- **Web Application**: Port 3001 (production), Port 3001 (development)
- **Server Application**: Port 3000
- **Database** (if used): Port 5432 (commented out in docker-compose.yml)

## Security Considerations

- All containers run as non-root users
- Minimal base images with only necessary dependencies
- Environment-specific configurations
- Proper file permissions and ownership

## Troubleshooting

### Build Issues
1. Make sure you have Docker and Docker Compose installed
2. Ensure `bun.lock` file exists (run `bun install` locally first)
3. Check that all package.json files are present

### Runtime Issues
1. Verify environment variables are set correctly
2. Check port availability (3001, 3000)
3. Ensure database connections (if applicable) are configured

### Performance Optimization
1. Use Docker BuildKit for faster builds: `DOCKER_BUILDKIT=1 docker build ...`
2. Utilize Docker layer caching
3. Consider using a `.dockerignore` file (already included) 