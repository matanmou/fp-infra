# ---------- Stage 1: build the Angular app ----------
# Angular 22 needs Node ^22.22.3 or ^24.15.0
FROM node:24-alpine AS build

WORKDIR /app
RUN apk add --no-cache git
ARG APP_REF=main
RUN git clone --filter=blob:none --no-checkout \
    https://github.com/matanmou/fp-app.git . && \
    git sparse-checkout set frontend && \
    git checkout ${APP_REF}

WORKDIR /app/frontend

RUN npm ci

# Copy the source and build for production
RUN npx ng build

# ---------- Stage 2: serve with nginx ----------
FROM nginx:1.25-alpine


# Built files from stage 1
RUN rm -rf /usr/share/nginx/html/

COPY --from=build /app/frontend/dist/matanmoDotCom/browser /usr/share/nginx/html
COPY --from=build /app/frontend/nginx/default.conf.template /etc/nginx/templates/default.conf.template
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
