# 🚀 Aplicação DevOps - Petronio Silva

Este projeto demonstra uma aplicação completa com frontend e backend, implementando práticas de DevOps incluindo containerização com Docker, controle de versão com Git, e automação de deploy com GitHub Actions na AWS.

## 📋 Requisitos do Projeto

- ✅ **Aplicação Completa**: Frontend (React) + Backend (Node.js/Express) com comunicação via API
- ✅ **Contêinerização**: Docker para ambos frontend e backend
- ✅ **Controle de Versão**: Git com branches Dev, Staging e Master
- ✅ **Automação**: GitHub Actions para CI/CD
- ✅ **Deploy**: AWS com ECS, ECR e ALB

## 🏗️ Arquitetura

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   AWS           │
│   (React)       │◄──►│   (Node.js)     │◄──►│   ECS + ECR     │
│   Porta 80      │    │   Porta 3001    │    │   + ALB         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Quick Start

### Pré-requisitos

- Node.js 18+
- Docker e Docker Compose
- Git
- Conta AWS
- Terraform (para infraestrutura)

### 1. Clone o Repositório

```bash
git clone https://github.com/ppsfafire/Devops-Petronio_Silva.git
cd Devops-Petronio_Silva
```

### 2. Instalação Local

```bash
# Instalar dependências
npm run install:all

# Executar em modo desenvolvimento
npm run dev
```

A aplicação estará disponível em:
- Frontend: http://localhost:3000
- Backend: http://localhost:3001

### 3. Executar com Docker

```bash
# Usar script de comandos Docker (recomendado)
./docker-commands.sh build
./docker-commands.sh up

# Ou usar Docker Compose diretamente
docker-compose up --build
```

**Imagens Docker Hub**: `ppsfafire/devops-backend` e `ppsfafire/devops-frontend`

## 🔧 Configuração da Infraestrutura AWS

### 1. Configurar AWS CLI

```bash
aws configure
```

### 2. Criar Bucket S3 para Terraform State

```bash
aws s3 mb s3://devops-petronio-silva-terraform-state
aws s3api put-bucket-versioning --bucket devops-petronio-silva-terraform-state --versioning-configuration Status=Enabled
```

### 3. Deploy da Infraestrutura

```bash
cd infrastructure

# Inicializar Terraform
terraform init

# Planejar deploy
terraform plan -var="environment=dev"

# Aplicar infraestrutura
terraform apply -var="environment=dev"
```

### 4. Configurar GitHub Secrets

No repositório GitHub, adicione os seguintes secrets:

- `AWS_ACCESS_KEY_ID`: Sua AWS Access Key
- `AWS_SECRET_ACCESS_KEY`: Sua AWS Secret Key

## 🔄 Fluxo de Deploy

### Branches e Ambientes

1. **Dev Branch** → Ambiente de Desenvolvimento
2. **Staging Branch** → Ambiente de Homologação  
3. **Master Branch** → Ambiente de Produção

### Processo de Deploy

1. **Push para branch** → Trigger do GitHub Actions
2. **Testes** → Execução de testes automatizados
3. **Build** → Criação das imagens Docker
4. **Push ECR** → Upload das imagens para AWS ECR
5. **Deploy ECS** → Atualização do serviço ECS
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
├── infrastructure/         # Terraform
│   ├── modules/            # Módulos Terraform
│   ├── main.tf            # Configuração principal
│   └── variables.tf       # Variáveis
├── .github/workflows/      # GitHub Actions
│   └── ci-cd.yml          # Pipeline CI/CD
├── docker-compose.yml      # Orquestração local
├── package.json           # Scripts principais
└── README.md              # Documentação
```

## 🛠️ Comandos Úteis

### Desenvolvimento Local

```bash
# Instalar dependências
npm run install:all

# Executar frontend e backend
npm run dev

# Executar apenas backend
npm run dev:backend

# Executar apenas frontend
npm run dev:frontend
```

### Docker

```bash
# Usar script de comandos (recomendado)
./docker-commands.sh build    # Build das imagens
./docker-commands.sh up       # Iniciar containers
./docker-commands.sh down     # Parar containers
./docker-commands.sh logs     # Ver logs
./docker-commands.sh status   # Status dos containers
./docker-commands.sh test     # Testar aplicação
./docker-commands.sh push     # Push para Docker Hub
./docker-commands.sh clean    # Limpar tudo

# Ou usar Docker Compose diretamente
docker-compose up --build
docker-compose up -d
docker-compose down
docker-compose logs -f
```

### Terraform

```bash
# Inicializar
terraform init

# Verificar sintaxe
terraform validate

# Planejar mudanças
terraform plan

# Aplicar mudanças
terraform apply

# Destruir infraestrutura
terraform destroy
```

## 🔍 Endpoints da API

### Backend (Porta 3001)

- `GET /api/health` - Status da API
- `GET /api` - Informações da API
- `GET /api/data` - Listar itens
- `POST /api/data` - Criar novo item

### Frontend (Porta 80)

- Interface web para interagir com a API

## 🧪 Testes

```bash
# Testes do backend
cd backend && npm test

# Testes do frontend
cd frontend && npm test
```

## 📊 Monitoramento

- **Health Checks**: Endpoint `/api/health`
- **Logs**: CloudWatch Logs (AWS)
- **Métricas**: ECS Service Metrics

## 🔒 Segurança

- Security Groups configurados
- HTTPS habilitado no ALB
- Headers de segurança no nginx
- Variáveis de ambiente para configurações sensíveis

## 🚨 Troubleshooting

### Problemas Comuns

1. **Porta já em uso**
   ```bash
   # Verificar processos
   lsof -i :3000
   lsof -i :3001
   
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

3. **Terraform erro de credenciais**
   ```bash
   # Verificar configuração AWS
   aws sts get-caller-identity
   ```

## 📞 Suporte

- **Autor**: Petronio Silva
- **GitHub**: [ppsfafire/Devops-Petronio_Silva](https://github.com/ppsfafire/Devops-Petronio_Silva.git)
- **Email**: [Seu email]

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

**🎯 Objetivo**: Demonstrar práticas completas de DevOps com uma aplicação real, desde desenvolvimento local até deploy automatizado em produção.
