# 🐳 Guia Docker - Aplicação DevOps

Este guia explica como usar Docker com a aplicação DevOps, incluindo configuração da conta Docker Hub `ppsfafire`.

## 📋 Informações das Imagens

### Imagens Docker Hub
- **Backend**: `ppsfafire/devops-backend:latest`
- **Frontend**: `ppsfafire/devops-frontend:latest`

### Tags Disponíveis
- `latest` - Versão mais recente
- `v1.0.0` - Versão específica (quando disponível)

## 🚀 Quick Start

### 1. Verificar Docker

```bash
# Verificar se Docker está instalado
docker --version

# Verificar se Docker está rodando
docker info
```

### 2. Build das Imagens

```bash
# Usar script automatizado (recomendado)
./docker-commands.sh build

# Ou build manual
docker build -t ppsfafire/devops-backend:latest ./backend
docker build -t ppsfafire/devops-frontend:latest ./frontend
```

### 3. Executar Containers

```bash
# Iniciar com script
./docker-commands.sh up

# Ou com Docker Compose
docker-compose up -d
```

### 4. Verificar Status

```bash
# Verificar status
./docker-commands.sh status

# Ver logs
./docker-commands.sh logs
```

## 🛠️ Comandos do Script Docker

O script `docker-commands.sh` oferece comandos simplificados:

```bash
./docker-commands.sh [comando]
```

### Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `build` | Build das imagens Docker |
| `up` | Iniciar containers |
| `down` | Parar containers |
| `restart` | Reiniciar containers |
| `logs` | Ver logs dos containers |
| `status` | Status dos containers |
| `test` | Testar aplicação |
| `clean` | Limpar containers e imagens |
| `push` | Push para Docker Hub |
| `pull` | Pull do Docker Hub |
| `help` | Mostrar ajuda |

## 🔐 Docker Hub

### Login no Docker Hub

```bash
# Login com sua conta ppsfafire
docker login

# Username: ppsfafire
# Password: [sua senha]
```

### Push das Imagens

```bash
# Push das imagens para Docker Hub
./docker-commands.sh push

# Ou manualmente
docker push ppsfafire/devops-backend:latest
docker push ppsfafire/devops-frontend:latest
```

### Pull das Imagens

```bash
# Pull das imagens do Docker Hub
./docker-commands.sh pull

# Ou manualmente
docker pull ppsfafire/devops-backend:latest
docker pull ppsfafire/devops-frontend:latest
```

## 📊 Monitoramento

### Verificar Containers

```bash
# Listar containers em execução
docker ps

# Listar todos os containers
docker ps -a

# Ver recursos utilizados
docker stats
```

### Verificar Imagens

```bash
# Listar imagens locais
docker images

# Listar imagens da conta ppsfafire
docker images | grep ppsfafire
```

### Logs dos Containers

```bash
# Logs em tempo real
./docker-commands.sh logs

# Logs específicos
docker logs devops-backend
docker logs devops-frontend

# Últimas 100 linhas
docker logs --tail 100 devops-backend
```

## 🧪 Testes

### Testar Aplicação

```bash
# Teste automatizado
./docker-commands.sh test

# Teste manual do backend
curl http://localhost:3001/api/health

# Teste manual do frontend
curl -I http://localhost:80
```

### Health Checks

```bash
# Verificar health do backend
curl -s http://localhost:3001/api/health | jq .

# Verificar se frontend responde
curl -s -I http://localhost:80 | head -1
```

## 🔧 Configuração Avançada

### Variáveis de Ambiente

```bash
# Criar arquivo .env
cp .env.example .env

# Editar variáveis
nano .env
```

### Portas Personalizadas

Editar `docker-compose.yml`:

```yaml
services:
  backend:
    ports:
      - "8080:3001"  # Mapear porta 8080 externa para 3001 interna
  
  frontend:
    ports:
      - "8081:80"    # Mapear porta 8081 externa para 80 interna
```

### Volumes Persistentes

```yaml
services:
  backend:
    volumes:
      - ./logs:/app/logs
      - ./data:/app/data
```

## 🚨 Troubleshooting

### Problemas Comuns

1. **Docker não está rodando**
   ```bash
   # Iniciar Docker Desktop
   # Ou verificar status
   docker info
   ```

2. **Porta já em uso**
   ```bash
   # Verificar processos na porta
   lsof -i :3001
   lsof -i :80
   
   # Parar containers
   ./docker-commands.sh down
   ```

3. **Imagem não encontrada**
   ```bash
   # Rebuild das imagens
   ./docker-commands.sh build
   
   # Ou pull do Docker Hub
   ./docker-commands.sh pull
   ```

4. **Erro de permissão**
   ```bash
   # Verificar permissões
   ls -la docker-commands.sh
   
   # Dar permissão de execução
   chmod +x docker-commands.sh
   ```

### Limpeza

```bash
# Limpar tudo
./docker-commands.sh clean

# Limpar manualmente
docker-compose down --rmi all --volumes --remove-orphans
docker system prune -a
```

## 📈 Performance

### Otimizações

1. **Multi-stage builds** (já implementado)
2. **Cache de dependências**
3. **Imagens Alpine** (já implementado)
4. **Compressão de imagens**

### Monitoramento de Recursos

```bash
# Ver uso de recursos
docker stats

# Ver tamanho das imagens
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

## 🔗 Links Úteis

- **Docker Hub**: https://hub.docker.com/u/ppsfafire
- **Documentação Docker**: https://docs.docker.com/
- **Docker Compose**: https://docs.docker.com/compose/

## 📞 Suporte

Para problemas específicos do Docker:

1. Verificar logs: `./docker-commands.sh logs`
2. Verificar status: `./docker-commands.sh status`
3. Testar aplicação: `./docker-commands.sh test`
4. Limpar e rebuild: `./docker-commands.sh clean && ./docker-commands.sh build`

---

**🐳 Docker configurado com sucesso para a conta ppsfafire!**
