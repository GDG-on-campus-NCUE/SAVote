FROM node:20-alpine AS builder

WORKDIR /app
RUN npm install -g pnpm

# Copy workspace config
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json turbo.json ./

# Copy package.json for all apps/packages
COPY apps/api/package.json apps/api/
COPY apps/web/package.json apps/web/
COPY packages/circuits/package.json packages/circuits/
COPY packages/crypto-lib/package.json packages/crypto-lib/
COPY packages/shared-types/package.json packages/shared-types/

RUN pnpm install --frozen-lockfile

COPY . .

# Build web
ENV VITE_API_BASE_URL=http://localhost:3000
ENV VITE_SAML_LOGIN_URL=http://localhost:3000/auth/saml/login
RUN pnpm turbo run build --filter=web...

FROM nginx:alpine
COPY --from=builder /app/apps/web/dist /usr/share/nginx/html
COPY apps/web/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
