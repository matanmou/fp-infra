# ---------- Stage 1: build the Angular app ----------
# Angular 22 needs Node ^22.22.3 or ^24.15.0
FROM node:24-alpine AS build

WORKDIR /app

RUN apk add --no-cache git
RUN git clone --filter=blob:none --no-checkout --depth 1 \
    https://github.com/matanmou/fp-app.git . && \
    git sparse-checkout set frontend && \
    git checkout

WORKDIR /app/frontend

RUN npm ci

# Copy the source and build for production
RUN npx ng build

# ---------- Stage 2: serve with nginx ----------
FROM nginx:1.25-alpine

# SPA config: unknown routes fall back to index.html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Built files from stage 1
RUN rm -rf /usr/share/nginx/html/

COPY --from=build /app/frontend/dist/matanmoDotCom/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
