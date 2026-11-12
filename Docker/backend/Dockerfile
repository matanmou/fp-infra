# ---------- Stage 1: build the NestJS app ----------
FROM node:18-alpine AS build

WORKDIR /app

# Install all dependencies (including dev, needed for nest build)
COPY package.json package-lock.json ./
RUN npm ci

# Copy the source and compile TypeScript -> dist/
COPY . .
RUN npm run build

# ---------- Stage 2: production image ----------
FROM node:18-alpine

WORKDIR /app
ENV NODE_ENV=production

# Production dependencies only
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Compiled code from stage 1
COPY --from=build /app/dist ./dist

# Database connection (override with -e or docker-compose)
ENV PORT=3000 \
    DB_HOST=localhost \
    DB_PORT=3306 \
    DB_NAME=ipflDB \
    DB_USER=root

EXPOSE 3000

# Run as the non-root "node" user that ships with the image
USER node

CMD ["node", "dist/src/main.js"]
