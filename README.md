# 🚀 Aplicação DevOps - Petronio Silva

Este projeto demonstra uma aplicação completa com frontend e backend, implementando práticas de DevOps incluindo containerização com Docker, controle de versão com Git, e automação de deploy com GitHub Actions na AWS EC2.

## 📋 Requisitos do Projeto

- ✅ **Aplicação Completa**: Frontend (React) + Backend (Node.js/Express) com comunicação via API
- ✅ **Contêinerização**: Docker para ambos frontend e backend
- ✅ **Controle de Versão**: Git com branches Dev, Staging e Master
- ✅ **Automação**: GitHub Actions para CI/CD
- ✅ **Deploy**: AWS EC2 com Docker Compose

## 🏗️ Arquitetura

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   AWS EC2       │
│   (React)       │◄──►│   (Node.js)     │◄──►│   Docker        │
│   Porta 3000    │    │   Porta 5000    │    │   Compose       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Quick Start

### Pré-requisitos

- Node.js 18+
- Docker e Docker Compose
- Git
- Conta AWS (EC2)
- Docker Hub (ppsfafire)

### 1. Clone o Repositório

```bash
git clone https://github.com/ppsfafire/Devops-Petronio_Silva.git
cd Devops-Petronio_Silva
```

### 2. Instalação Local

```bash
# Instalar dependências do backend
cd backend && npm install

# Instalar dependências do frontend
cd frontend && npm install

# Executar backend
cd backend && npm start

# Executar frontend (em outro terminal)
cd frontend && npm start
```

A aplicação estará disponível em:
- Frontend: http://localhost:3000
- Backend: http://localhost:5000

### 3. Executar com Docker

```bash
# Build das imagens
docker-compose build

# Executar containers
docker-compose up

# Executar em background
docker-compose up -d

# Parar containers
docker-compose down
```

**Imagens Docker Hub**: `ppsfafire/devops-backend` e `ppsfafire/devops-frontend`

### 4. Deploy Automático (GitHub Actions)

O deploy é automático via GitHub Actions quando você faz push para as branches:

```bash
# Deploy para desenvolvimento
git push origin dev

# Deploy para staging
git push origin staging

# Deploy para produção
git push origin master
```

**Servidor EC2**: `18.117.195.190` (us-east-2)
- **Frontend**: http://18.117.195.190:3000
- **Backend**: http://18.117.195.190:5000

### 5. Configurar GitHub Actions

Configure os seguintes secrets no GitHub:

- `DOCKER_USERNAME`: `ppsfafire`
- `DOCKER_PASSWORD`: Sua senha do Docker Hub
- `EC2_SSH_KEY`: Conteúdo da chave SSH privada (.pem)

**Deploy Automático**: Push para `dev`, `staging` ou `master` → Deploy automático no EC2

## 🔧 Configuração da Infraestrutura AWS

### 1. Configurar EC2

- **Instância**: Ubuntu Server 22.04 LTS
- **Tipo**: t2.micro ou superior
- **Security Group**: Portas 22 (SSH), 3000 (Frontend), 5000 (Backend)
- **IP Público**: 18.117.195.190

### 2. Configurar Docker no EC2

```bash
# Conectar via SSH
ssh -i PPDS.pem admin@18.117.195.190

# Instalar Docker
sudo apt update
sudo apt install docker.io docker-compose

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
```

### 3. Configurar GitHub Secrets

No repositório GitHub, adicione os seguintes secrets:

- `DOCKER_USERNAME`: `ppsfafire`
- `DOCKER_PASSWORD`: Sua senha do Docker Hub
- `EC2_SSH_KEY`: Conteúdo da chave SSH privada (.pem)

## 🔄 Fluxo de Deploy

### Branches e Ambientes

1. **Dev Branch** → Ambiente de Desenvolvimento
2. **Staging Branch** → Ambiente de Homologação  
3. **Master Branch** → Ambiente de Produção

### Processo de Deploy

1. **Push para branch** → Trigger do GitHub Actions
2. **Testes** → Execução de testes automatizados
3. **Build** → Criação das imagens Docker
4. **Push Docker Hub** → Upload das imagens para Docker Hub
5. **Deploy EC2** → Deploy via SSH no servidor EC2
6. **Verificação** → Health check da aplicação

## 📁 Estrutura do Projeto

```
Devops-Petronio_Silva/
├── backend/                 # API Node.js/Express
│   ├── server.js           # Servidor principal
│   ├── package.json        # Dependências
│   └── Dockerfile          # Container do backend
├── frontend/               # Aplicação React
│   ├── src/                # Código fonte
│   ├── public/             # Arquivos públicos
│   ├── package.json        # Dependências
│   └── Dockerfile          # Container do frontend
├── .github/workflows/      # GitHub Actions
│   └── ci-cd.yml          # Pipeline CI/CD
├── docker-compose.yml      # Orquestração local
└── README.md              # Documentação
```

## 🛠️ Comandos Úteis

### Desenvolvimento Local

```bash
# Instalar dependências do backend
cd backend && npm install

# Instalar dependências do frontend
cd frontend && npm install

# Executar backend
cd backend && npm start

# Executar frontend
cd frontend && npm start
```

### Docker

```bash
# Build das imagens
docker-compose build

# Executar containers
docker-compose up

# Executar em background
docker-compose up -d

# Parar containers
docker-compose down

# Ver logs
docker-compose logs -f

# Status dos containers
docker-compose ps
```

### GitHub Actions

```bash
# Deploy para desenvolvimento
git push origin dev

# Deploy para staging
git push origin staging

# Deploy para produção
git push origin master
```

## 🔍 Endpoints da API

### Backend (Porta 5000)

- `GET /api/health` - Status da API
- `GET /api` - Informações da API
- `GET /api/data` - Listar itens
- `POST /api/data` - Criar novo item

### Frontend (Porta 3000)

- Interface web para interagir com a API

## 🧪 Testes

```bash
# Testes do backend
cd backend && npm test

# Testes do frontend
cd frontend && npm test

# Testes automatizados (GitHub Actions)
git push origin staging
```

## 📊 Monitoramento

- **Health Checks**: Endpoint `/api/health`
- **Logs**: Docker logs no EC2
- **Status**: `docker-compose ps`
- **GitHub Actions**: Pipeline de CI/CD

## 🔒 Segurança

- Security Groups configurados (portas 22, 3000, 5000)
- Headers de segurança no nginx
- Variáveis de ambiente para configurações sensíveis
- Chaves SSH protegidas via GitHub Secrets

## 🚨 Troubleshooting

### Problemas Comuns

1. **Porta já em uso**
   ```bash
   # Verificar processos
   lsof -i :3000
   lsof -i :5000
   
   # Matar processo
   kill -9 <PID>
   ```

2. **Docker não inicia**
   ```bash
   # Verificar se Docker está rodando
   docker info
   
   # Reiniciar Docker
   sudo systemctl restart docker
   ```

3. **GitHub Actions falha**
   ```bash
   # Verificar secrets configurados
   # DOCKER_USERNAME, DOCKER_PASSWORD, EC2_SSH_KEY
   
   # Verificar logs do pipeline
   # https://github.com/ppsfafire/Devops-Petronio_Silva/actions
   ```

4. **EC2 não responde**
   ```bash
   # Verificar status da instância
   # Verificar Security Group (portas 3000, 5000)
   # Verificar logs do Docker
   ssh admin@18.117.195.190 "docker-compose logs"
   ```

## 📞 Suporte

- **Autor**: Petronio Silva
- **Email**: petroniopereirasilva@pos.fafire.br
- **GitHub**: [ppsfafire/Devops-Petronio_Silva](https://github.com/ppsfafire/Devops-Petronio_Silva.git)
- **Aplicação**: http://18.117.195.190:3000

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

**🎯 Objetivo**: Demonstrar práticas completas de DevOps com uma aplicação real, desde desenvolvimento local até deploy automatizado em produção.
