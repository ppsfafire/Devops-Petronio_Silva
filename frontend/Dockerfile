# Build stage
FROM node:18-alpine as build

LABEL maintainer="ppsfafire"
LABEL version="1.0"
LABEL description="Frontend da aplicação DevOps - Petronio Silva"

WORKDIR /app

# Copiar package.json e package-lock.json
COPY package*.json ./

# Configurar npm para usar cache e evitar rate limits
RUN npm config set registry https://registry.npmjs.org/ && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 20000 && \
    npm config set fetch-retry-maxtimeout 120000

# Instalar dependências com retry
RUN npm ci --no-audit --no-fund || \
    (sleep 30 && npm ci --no-audit --no-fund) || \
    (sleep 60 && npm ci --no-audit --no-fund)

# Copiar código da aplicação
COPY . .

# Build da aplicação
RUN npm run build

# Production stage
FROM nginx:alpine

LABEL maintainer="ppsfafire"
LABEL version="1.0"
LABEL description="Frontend da aplicação DevOps - Petronio Silva"

# Copiar build do React
COPY --from=build /app/build /usr/share/nginx/html

# Copiar configuração do nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Expor porta
EXPOSE 3000

# Comando para iniciar nginx
CMD ["nginx", "-g", "daemon off;"]
