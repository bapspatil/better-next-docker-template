# Multi-stage Dockerfile for the full-stack application
FROM oven/bun:1 AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Copy package files for the entire monorepo
COPY package.json bun.lock* ./
COPY turbo.json ./
COPY apps/web/package.json ./apps/web/
COPY apps/server/package.json ./apps/server/

# Install dependencies
RUN bun install --frozen-lockfile

# Build stage for both applications
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build both web and server applications
RUN bun run build

# Production stage for web application
FROM base AS web-runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy the built Next.js application
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/static ./apps/web/.next/static
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/public ./apps/web/public

USER nextjs

EXPOSE 3001
ENV PORT=3001
ENV HOSTNAME="0.0.0.0"

CMD ["bun", "apps/web/server.js"]

# Production stage for server application
FROM base AS server-runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 serveruser

# Copy the built server application
COPY --from=builder --chown=serveruser:nodejs /app/apps/server/dist ./apps/server/dist
COPY --from=builder --chown=serveruser:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=serveruser:nodejs /app/apps/server/package.json ./apps/server/

USER serveruser

EXPOSE 3000

CMD ["bun", "run", "apps/server/dist/src/index.js"]

# Full-stack production stage (both web and server)
FROM base AS fullstack
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 appuser

# Copy both applications
COPY --from=builder --chown=appuser:nodejs /app/apps/web/.next/standalone ./web/
COPY --from=builder --chown=appuser:nodejs /app/apps/web/.next/static ./web/apps/web/.next/static
COPY --from=builder --chown=appuser:nodejs /app/apps/web/public ./web/apps/web/public
COPY --from=builder --chown=appuser:nodejs /app/apps/server/dist ./server/dist
COPY --from=builder --chown=appuser:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:nodejs /app/apps/server/package.json ./server/

# Create startup script
COPY --chown=appuser:nodejs <<EOF /app/start.sh
#!/bin/bash
# Start server in background
cd /app && bun run server/dist/src/index.js &
# Start web application
cd /app/web && bun apps/web/server.js
EOF

RUN chmod +x /app/start.sh

USER appuser

EXPOSE 3001 3000

CMD ["/app/start.sh"] 