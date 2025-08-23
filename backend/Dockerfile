FROM node:18-alpine

LABEL maintainer="ppsfafire"
LABEL version="1.0"
LABEL description="Backend da aplicação DevOps - Petronio Silva"

WORKDIR /app

# Copiar package.json e package-lock.json
COPY package*.json ./

# Instalar dependências
RUN npm ci --only=production

# Copiar código da aplicação
COPY . .

# Expor porta
EXPOSE 3001

# Comando para iniciar a aplicação
CMD ["npm", "start"]
