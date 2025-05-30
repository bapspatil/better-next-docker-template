# Use Bun's official image as base
FROM oven/bun:1 AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Copy package files
COPY package.json bun.lock* ./
COPY apps/server/package.json ./apps/server/
COPY turbo.json ./

# Install dependencies
RUN bun install --frozen-lockfile

# Build the application
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build the server
RUN bun run build --filter=server

# Production image
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 serveruser

# Copy the built application
COPY --from=builder --chown=serveruser:nodejs /app/apps/server/dist ./apps/server/dist
COPY --from=builder --chown=serveruser:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=serveruser:nodejs /app/apps/server/package.json ./apps/server/

USER serveruser

EXPOSE 8000

CMD ["bun", "run", "apps/server/dist/src/index.js"] 