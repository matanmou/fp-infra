# ---------- Stage 1: build ----------
FROM node:22-alpine AS build

WORKDIR /app
RUN apk add --no-cache git
ARG APP_REF=main
RUN git clone --filter=blob:none --no-checkout \
      https://github.com/matanmou/fp-app.git . && \
    git sparse-checkout set backend && \
    git checkout ${APP_REF}

WORKDIR /app/backend
# install everything, compile, then drop devDependencies
RUN npm ci && \
    npm run build && \
    npm prune --omit=dev

# ---------- Stage 2: runtime ----------
FROM node:22-alpine

ENV NODE_ENV=production
WORKDIR /app

COPY --from=build --chown=node:node /app/backend/package*.json ./
COPY --from=build --chown=node:node /app/backend/node_modules ./node_modules
COPY --from=build --chown=node:node /app/backend/dist ./dist

USER node
EXPOSE 3000

CMD ["node", "dist/src/main"]