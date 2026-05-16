# syntax=docker/dockerfile:1

# ---- Build stage ----
FROM node:26-alpine AS builder

WORKDIR /app

# Node 26 alpine ships without corepack — install pnpm directly. Pin to the
# same major as `packageManager` in package.json for reproducibility.
# Skip the playwright chromium download: the image only serves the built
# output, tests run from the host against the container.
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
RUN npm install -g pnpm@11

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile --ignore-scripts

COPY . .
RUN pnpm run build

# ---- Serve stage ----
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

# nginx:alpine runs nginx in the foreground as entrypoint — no CMD needed.
